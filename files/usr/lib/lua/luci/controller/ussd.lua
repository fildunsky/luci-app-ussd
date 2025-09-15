module("luci.controller.ussd", package.seeall)

function index()
    local m = entry({"admin", "modem", "ussd"}, call("action_index"), _("USSD"), 60)
    m.acl_depends = { "luci-app-ussd" }
end

function action_index()
    local http = require "luci.http"
    local sys = require "luci.sys"

    local code = http.formvalue("code") or ""
    local output

    if code and code ~= "" then
        local escaped = code:gsub('"', '\\"')
        output = sys.exec("mmcli -m 0 --3gpp-ussd-initiate=\"" .. escaped .. "\" 2>&1")
        local inner = output and output:match("'(.-)'")
        if inner and inner ~= "" then
            output = inner
        end
    end

    luci.template.render("ussd/index", {
        code = code,
        output = output
    })
end
