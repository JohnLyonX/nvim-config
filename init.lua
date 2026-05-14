require("johnlyon.core")
require("johnlyon.lazy")

-- lazy 加载完所有非 lazy 插件（含主题）后，应用上次保存的主题
require("johnlyon.core.colorscheme").apply()
