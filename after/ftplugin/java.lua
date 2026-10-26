local jdtls = require "jdtls"
local home = os.getenv "HOME"

local lombok_jar = home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar"
local workspace = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

jdtls.start_or_attach {
  cmd = {
    "jdtls",
    "--jvm-arg=-javaagent:" .. lombok_jar,
    "-data",
    workspace,
  },
  root_dir = vim.fs.dirname(vim.fs.find({ "pom.xml", "build.gradle", ".git" }, { upward = true })[1]),
  settings = {
    java = {
      inlayHints = { parameterNames = { enabled = "all" } },
      format = { enabled = true },
    },
  },
}
