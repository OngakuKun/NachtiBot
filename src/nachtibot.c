#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include <pthread.h>
#include <assert.h>

#include "concord/discord.h"
#include "concord/log.h"

void on_ready(struct discord *client, const struct discord_ready *event)
{
    log_info("NachtiBot succesfully connected to Discord!");
    log_info("    > Logged-in as %s#%s", event->user->username, event->user->discriminator);
}

void on_dm_receive(struct discord *client, const struct discord_message *event)
{
    if (event->author->bot) return;

    log_trace("[DM RECEIVE][%s]:%s\n", event->author->username, event->content);
}

int main(int argc, char *argv[])
{
    const char *config_file;
    if (argc > 1)
        config_file = argv[1];
    else
        config_file = "config.json";

    ccord_global_init();
    struct discord *client = discord_config_init(config_file);
    struct discord_presence_update statusUpdate = { 0 };
    assert(NULL != client && "Couldn't initialize client");

    discord_add_intents(client, DISCORD_GATEWAY_MESSAGE_CONTENT);

    discord_set_on_ready(client, &on_ready);
    discord_set_on_message_create(client, &on_dm_receive);

    /* Keep just DISCORD_GATEWAY_DIRECT_MESSAGES */
    discord_remove_intents(client, DISCORD_GATEWAY_GUILD_MESSAGES);

    discord_run(client);
    discord_set_presence(client, NULL);

    discord_cleanup(client);
    ccord_global_cleanup();
}
