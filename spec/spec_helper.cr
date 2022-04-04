require "spec"
require "../src/wayback"

# Clears all Webmock stubs and sets `Webmock.allow_net_connect` to false.
require "webmock"
Spec.before_each &->WebMock.reset
