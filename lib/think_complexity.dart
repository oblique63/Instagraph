library think_complexity;

part 'vertex.dart';
part 'edge.dart';
part 'graph.dart';
part 'random_graph.dart';


main() {
    var vertices = [
        new Vertex('a'),
        new Vertex('b'),
        new Vertex('c'),
        new Vertex('d'),
        new Vertex('e'),
        new Vertex('f'),
        new Vertex('g'),
        new Vertex('h'),
        new Vertex('i'),
        new Vertex('j')
    ];

    var vertex_count = 6;
    var regular_degree = 4;

    var g = new Graph(vertices.take(vertex_count));
    print("Init Edge-less Graph: ${g.vertices.length} vertices");

    g.add_regular_edges(regular_degree);

    var first_degree = g.degree_of(vertices[0]);
    print("Degrees at '${vertices[0].label}': $first_degree");

    print("Is Regular: ${g.is_regular}");

    g.edges.forEach((edge) => print("${edge.v1.label} - ${edge.v2.label}"));

    print("Is Regular with $regular_degree degrees: ${g.is_regular && first_degree == regular_degree}");

    //g.add_all_edges();
    //print("Is Complete: ${g.is_complete}");
    //print("Complete Graph Edge Count: ${g.edges.length}");
}