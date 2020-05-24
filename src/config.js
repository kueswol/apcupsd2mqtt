module.exports = require('yargs')
    .env('APCUPSD2MQTT')
    .usage('Usage: $0 [options]')
    .describe('mqtturl', 'mqtt broker url.')
    .describe('name', 'topic prefix')
    .describe('ups', 'UPS Name. Is overwritten if apcupsd supplies a name')
    .describe('interval', 'Interval in seconds to poll apcaccess')
    .describe('changes', 'Don\'t publish unchanged values')
    .boolean('changes')
    .describe('verbosity', 'possible values: "error", "warn", "info", "debug"')
    .alias({
        h: 'help',
        i: 'interval',
        m: 'mqtturl',
        n: 'name',
        u: 'ups',
        v: 'verbosity'
    })
    .default({
        interval: 10,
        mqtturl: 'mqtt://127.0.0.1',
        name: 'ups',
        ups: 'ups',
        verbosity: 'info'
    })
    .version()
    .help('help')
    .argv;
