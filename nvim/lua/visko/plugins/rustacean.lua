return {
	"mrcjkb/rustaceanvim",
	version = "^4",
	ft = { "rust" },
	config = function(_, opts)
		vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
	end,
	opts = {
		server = {
			on_attach = function(client, bufnr)
				require("visko.lsp_mappings").setup_lsp_keymaps(client, bufnr)
				require("visko.lsp_mappings").on_attach(client, bufnr)
			end,
			settings = {
				["rust-analyzer"] = {
					-- cargo = {
					--     features = {"sqlite"}
					-- },
					diagnostics = {
						disabled = { "incorrect-ident-case" },
					},
					completion = {
						fullFunctionSignatures = {
							enable = true,
						},
						privateEditable = {
							enable = true,
						},
						postfix = {
							enable = false,
						},
					},
					checkOnSave = {
						command = "clippy",
					},
					procMacro = {
						enable = true,
						ignored = {
							testrunner_derive = { "mytest" },
							tokio_macros = {
								"main",
								"test",
							},
							tracing_attributes = {
								"instrument",
							},
						},
					},
					inlayHints = {
						bindingModeHints = {
							enable = true,
						},
						closureReturnTypeHints = {
							enable = true,
						},
						lifetimeElisionHints = {
							enable = true,
						},
						typeHints = {
							hideClosureInitialization = true,
						},
					},
				},
			},
		},
	},
}
