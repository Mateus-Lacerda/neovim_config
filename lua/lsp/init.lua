-- Função auxiliar para verificar se o projeto usa 'ty'
local function should_use_ty()
    -- Encontra o pyproject.toml na raiz do projeto (busca recursiva para cima)
    local root_files = vim.fs.find({ 'pyproject.toml' }, { upward = true, path = vim.fn.getcwd() })

    if #root_files == 0 then return false end

    local file = io.open(root_files[1], "r")
    if not file then return false end

    local content = file:read("*a")
    file:close()

    -- Procura pela string '[tool.ty]' no conteúdo do arquivo
    if content:find("%[tool%.ty%]") then
        return true
    end

    return false
end

-- Configuração dos LSPs
local lsp_servers = {
    "ts_ls",
    "ruff",
    "gopls",
    "rust_analyzer",
    "clangd",
    "lua_ls"
}

-- Decide qual LSP de Python adicionar à lista
if should_use_ty() then
    table.insert(lsp_servers, "ty")
else
    -- Fallback padrão (pode ser pyright, basedpyright ou ruff)
    table.insert(lsp_servers, "pyright")
end

-- Habilita a lista final
vim.lsp.enable(lsp_servers)
