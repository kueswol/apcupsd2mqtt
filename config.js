module.exports = require('yargs')
    .env('APCUPSD2MQTT')
    .usage('Usage: $0 [options]')
    .describe('mqtt-url', 'mqtt broker url.')
    .describe('name', 'topic prefix')
    .describe('ups-name', 'UPS Name. Is overwritten if apcupsd supplies a name')
    .describe('interval', 'Interval in seconds to poll apcaccess')
    .describe('publish-changes-only', 'Don\'t publish unchanged values')
    .boolean('publish-changes-only')
    .describe('verbosity', 'possible values: "error", "warn", "info", "debug"')
    .alias({
        h: 'help',
        i: 'interval',
        m: 'mqtt-url',
        n: 'name',
        u: 'ups-name',
        v: 'verbosity'
    })
    .default({
        interval: 10,
        mqtt-url: 'mqtt://127.0.0.1',
        name: 'ups',
        ups-name: 'ups',
        verbosity: 'info'
    })
    .version()
    .help('help')
    .argv;
