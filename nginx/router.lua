local cjson = require "cjson"
local pg = require("resty.postgres")
local db = pg:new()

db:set_timeout(3000)

-- Hardcoded values for now...these will surely be made into env vars shortly
local ok, err = db:connect({
  host="aa6vyszgaxkja0.cuuxw5vnhy2g.us-east-1.rds.amazonaws.com",
  port=5432,
  database="ebdb",
  user="franklin",
  password="foobar",
  compact=false
})

if not ok then
    ngx.say(err)
end

-- Will obviously need a way to make this more 'dynamic'. We have the url already so it should not be hard
local res, err = db:query("SELECT path FROM builder_site WHERE url='istrategylabs-milagro.islstatic.com'")

if not res then
   ngx.say("Could not get result")
end

-- Will need to work with the formatting of this output, but it's a start
ngx.say("result #1: ", cjson.encode(res))
