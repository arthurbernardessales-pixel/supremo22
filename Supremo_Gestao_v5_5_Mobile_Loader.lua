-- Loader para o Supremo Gestao v5.5 (compatível com mobile / Delta)
local RAW_URL = "COLE_AQUI_O_LINK_RAW_DO_SCRIPT"

local function runSupremoLoader()
	local okFetch, bodyOrErr = pcall(function()
		return game:HttpGet(RAW_URL)
	end)

	if not okFetch or type(bodyOrErr) ~= "string" or #bodyOrErr == 0 then
		warn("[Supremo Loader] Falha ao baixar o script:", tostring(bodyOrErr))
		return
	end

	local fn, compileErr = loadstring(bodyOrErr)
	if not fn then
		warn("[Supremo Loader] Falha ao compilar Lua:", tostring(compileErr))
		return
	end

	local okRun, runErr = pcall(fn)
	if not okRun then
		warn("[Supremo Loader] Erro ao executar o script:", tostring(runErr))
	end
end

runSupremoLoader()
