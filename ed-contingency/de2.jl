using Graphs, ArgParse, BenchmarkTools

function parse_commandline()
    s = ArgParseSettings()
    @add_arg_table s begin
        "--iter_num"
            help = "Número de iterações para execução do DE"
            arg_type = Int
            default = 10
        "--beta_min"
            help = "Valor mínimo do parâmetro de mutação"
            arg_type = Float64
            default = 0.2
        "--beta_max"
            help = "Valor máximo do parâmetro de mutação"
            arg_type = Float64
            default = 0.8
        "--voltages"
            help = "Arquivo com as tensões dos nós"
            arg_type = String
            required = true
        "--impedances"
            help = "Arquivo com as impedâncias das arestas"
            arg_type = String
            required = true
        "grafo"
            help = "Arquivo com o grafo em lista de arestas"
            arg_type = String
            required = true
        "k"
            help = "Número de arestas removidas simultaneamente"
            arg_type = Int
            required = true
        "pop"
            help = "Tamanho da população do DE"
            arg_type = Int
            required = true
        "crossover"
            help = "Taxa de crossover do DE"
            arg_type = Float64
            required = true
    end

    return parse_args(s)
end

function validate_args(args)
    if args["k"] <= 0
        error("O número de arestas removidas simultaneamente deve ser maior que 0.")
    end
    if args["pop"] <= 0
        error("O tamanho da população deve ser maior que 0.")
    end
    if args["crossover"] <= 0.0 || args["crossover"] > 1.0
        error("A taxa de crossover deve estar entre 0 e 1.")
    end
    if !isfile(args["grafo"])
        error("O arquivo especificado não existe.")
    end
    if !isfile(args["voltages"])
        error("O arquivo de tensões especificado não existe.")
    end
    if !isfile(args["impedances"])
        error("O arquivo de impedâncias especificado não existe.")
    end
end

function load_complex_vector(filename::String)
    data = readdlm(filename, ',')
    return Complex{Float64}[Complex(d[1], d[2]) for d in eachrow(data)]
end

# Echo das entradas
args = parse_commandline()
validate_args(args)
for (arg, val) in args
    println("$arg  =>  $val")
end

ARQ = args["grafo"]
K = args["k"]
iter_num = args["iter_num"]
beta_min = args["beta_min"]
beta_max = args["beta_max"]
pop = args["pop"]
crossover = args["crossover"]
voltages_file = args["voltages"]
impedances_file = args["impedances"]

include("cfb.jl")
using Main.CFB

NOME = string(split(ARQ, ".")[1])
g = read_edgelist(ARQ)

# Carregar tensões e impedâncias
voltages = load_complex_vector(voltages_file)
impedances = load_complex_vector(impedances_file)

# Calcular fluxos de potência
power_flows = calc_power_flow(g, voltages, impedances)

cfb_de(g, K, pop, crossover, beta_min, beta_max, iter_num, power_flows, NOME)
