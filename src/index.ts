import Discord from 'discord.js';
import { App } from '@octokit/app';
import type { Octokit } from '@octokit/core';

const bot = new Discord.Client();
const token = process.env.DISCORD_BOT_TOKEN || '';
const prefix = '/im:';
const color = 0xffaa00;

const repository = {
  owner: process.env.REPOSITORY_OWNER || '',
  name: process.env.REPOSITORY_NAME || '',
};

const ghbot = new App({
  appId: 88735,
  privateKey: process.env.GH_PRIVATE_KEY || '',
  oauth: {
    clientId: '',
    clientSecret: process.env.GH_CLIENT_SECRET || '',
  },
});

let ghok: Octokit;
(async () => {
  for await (const { octokit, installation } of ghbot.eachInstallation.iterator()) {
    if (installation.account.login === repository.owner) ghok = octokit;
  }
})();

bot.on('ready', () => {
  console.log(`Logged in as ${bot.user?.tag}`);
});
bot.on('message', (msg) => {
  if (!msg.content.startsWith(prefix)) return;
  if (!ghok) return;
  const cmds = msg.content.substr(prefix.length).split(/\s+/);
  const cmd = cmds.shift();
  const opts = cmds.join(' ');

  switch (cmd) {
    case 'help':
    case '':
      msg.channel.send(new Discord.MessageEmbed({
        color,
        description: 'usage',
        fields: [
          { name: `${prefix}add IDEA_TITLE [DESCRIPTION]`, value: 'Register an idea to issue' },
          { name: `${prefix}help`, value: 'Display thi help message' },
        ],
        title: 'Idea Manager help',
      })).catch(console.error);
      break;
    case 'add':
      const [title, ...descriptions] = opts.split(/\s+/);
      if (title === '') {
        msg.channel.send(`USAGE: ${prefix}add IDEA_TITLE [DESCRIPTION]`);
        break;
      }
      ghok.request('POST /repos/:owner/:repo/issues', {
        owner: repository.owner,
        repo: repository.name,
        title: opts,
        body: descriptions.join(' '),
      }).then((res) => (200 <= res.status && res.status < 300)
        ? msg.channel.send(`Added to ${res.data.html_url}`)
        : msg.channel.send('Failed')
      ).catch(console.error);
      break;
  }
});

bot.login(token);
