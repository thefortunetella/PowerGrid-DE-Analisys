include("cfb/cfb.jl")
using Main.CFB, BenchmarkTools

# Escolha do arquivo a ser utilizado
sistema = "ieee300"
arquivo = "ieee300.txt"

# Carregar o grafo a partir do arquivo
println("------ ieee300 -------")
g = CFB.read_edgelist(arquivo)

# Definir tensões e impedâncias (exemplos, você pode ajustá-los conforme necessário)
voltages = Complex{Float64}[1.0 + 0.0im for i in 1:nv(g)]
impedances = Complex{Float64}[0.01 + 0.05im for i in 1:ne(g)]

# Calcular os fluxos de potência
power_flows = CFB.calc_power_flow(g, voltages, impedances)

# Função para medir e imprimir o tempo de execução
function measure_time(f, args...)
    start = time()
    result = f(args...)
    println("Tempo de execução: ", time() - start, " segundos")
    return result
end

# Chamadas ao cálculo da CFB com fluxos de potência como pesos
@time measure_time(CFB.cfb_de, g, 1, 100, 0.7, 0.2, 0.8, 10, power_flows, sistema)
@time measure_time(CFB.cfb_de, g, 2, 100, 0.7, 0.2, 0.8, 10, power_flows, sistema)
@time measure_time(CFB.cfb_de, g, 3, 100, 0.7, 0.2, 0.8, 10, power_flows, sistema)
