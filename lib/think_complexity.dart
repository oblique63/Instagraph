library think_complexity;

part 'vertex.dart';
part 'edge.dart';
part 'graph.dart';
part 'random_graph.dart';

List<int>
valid_regular_degrees(int graph_vertices) {
    assert(graph_vertices > 1);

    List valid_degrees = [];
    int degree_increment;

    if (graph_vertices.isEven)
        degree_increment = 1;
    else
        degree_increment = 2;

    for (int i = degree_increment; i < graph_vertices; i += degree_increment) {
        valid_degrees.add(i);
    }

    return valid_degrees;
}


const int
GRAPH_VERTEX_COUNT = 9;

const List vertex_names = const ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];

main() {
    List<Vertex> vertices = new List.generate(GRAPH_VERTEX_COUNT, (index) => new Vertex(vertex_names[index]) );

    var g = new Graph(vertices);
    print("Edge-less Graph with ${g.vertices.length} vertices\n");

    for (int degrees in valid_regular_degrees(g.vertices.length)) {
        print('Adding Regular Edges with $degrees Degrees...');
        g.add_regular_edges(degrees);

        print("  Is Regular: ${g.is_regular}");

        var first_degree = g.degree_of(vertices[0]);
        bool regular_with_degrees = g.is_regular && first_degree == degrees;

        print("  Is Regular with $degrees degrees: $regular_with_degrees");

        if (!regular_with_degrees) {
            print("  Degrees at '${vertices[0].label}': $first_degree");
        }

        if (!g.is_regular) {
            print("  Edges:");
            g.edges.forEach((edge) => print("    ${edge.v1.label} - ${edge.v2.label}"));

            print("  Vertex Degrees:");
            g.vertices.forEach((vertex) => print("    ${vertex.label}: ${g.degree_of(vertex)}"));
        }
        print('');
    }

    //g.add_all_edges();
    //print("Is Complete: ${g.is_complete}");
    //print("Complete Graph Edge Count: ${g.edges.length}");
}