#!/usr/bin/env ruby

# frozen_string_literal: true

require 'discorb'
require 'rufus-scheduler'
require 'logger'

require 'yaml'

log = Logger.new($stdout)

config = YAML.load_file('config.yml', symbolize_names: true)
reminders = YAML.load_file('reminders.yml')

def response(name)
  @responses ||= YAML.load_file('responses.yml', symbolize_names: true)

  @responses[name].sample
end

intents = Discorb::Intents.new
intents.message_content = true

client = Discorb::Client.new(
  intents:,
  logger: log,
  fetch_member: true
)

def reply(msg, content)
  no_reply_ping = Discorb::AllowedMentions.new(replied_user: false)

  content = response(content) if content.is_a? Symbol

  msg.reply(content, allowed_mentions: no_reply_ping)
end

client.on :message do |msg|
  next if msg.author.bot?
  next unless config[:allowed_servers].include? msg.guild.id

  text = msg.content
  next unless text.delete_prefix! client.user.mention

  text.strip!

  case text
  when /^.*(please|).*hug\b/
    reply(msg, :hug)
  when /^help$/
    reply(msg, :help)
  else
    reply(msg, :not_found)
  end
end

client.run(config[:token])
