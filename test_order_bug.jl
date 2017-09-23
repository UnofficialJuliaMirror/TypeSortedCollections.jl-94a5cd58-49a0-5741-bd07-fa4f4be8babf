using Base.Test
using TypeSortedCollections

module M
g(x::Int64, y1::Float64, y2::Float64) = x * y1 - y2
g(x::Float64, y1::Float64, y2::Float64) = x + y1 - y2
end

@testset "broadcast! length mismatch" begin
    x = Number[3.; 4; 5]
    sortedx = TypeSortedCollection(x)
    results = rand(length(x) + 1)
    y1 = rand()
    y2 = rand(Int)
    @test_throws DimensionMismatch results .= M.g.(sortedx, y1, y2)
end

@testset "broadcast! matching indices" begin
    x = Number[3.; 4; 5]
    sortedx = TypeSortedCollection(x)
    y1 = rand()
    y2 = [7.; 8.; 9.]
    sortedy2 = TypeSortedCollection(y2)
    results = similar(x, Float64)
    broadcast!(M.g, results, sortedx, y1, sortedy2)
    @allocated broadcast!(M.g, results, sortedx, y1, sortedy2)
end

