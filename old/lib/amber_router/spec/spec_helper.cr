require "spec"
require "../src/amber_router"

def build
  Amber::Router::RouteSet(Symbol).new.tap do |router|
    router.add "/get", :root
  end
end

def build(&block)
  router = build
  with router yield
  router
end
