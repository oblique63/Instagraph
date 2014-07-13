import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'package:think_complexity/think_complexity.dart';

const List
VERTEX_NAMES = const
    [ 'a','b','c','d','e','f','g','h','i','j','k','l','m',
      'n','o','p','q','r','s','t','u','v','w','x','y','z' ];

Graph graph;

main() {
    useVMConfiguration();

    group("Graph Initialization:", initializeGraphs);
    group("Vertex Insertion + Removal:", addRemoveVertices);
    group("Edge Insertion + Removal:", addRemoveEdges);
    group("Vertex Degrees:", testDegrees);
    group("Graph Completeness:", testCompleteness);
    group("Graph Regularity:", testRegularity);
}

initializeGraphs() {
    int vertex_count = 4;
    int edge_count = vertex_count-1;
    List<Vertex> vertices = generateVertices(vertex_count);
    List<Edge> edges = generateEdges(edge_count);

    Matcher initialized_properly = allOf(returnsNormally, isNotNull);

    test("With No Edges or Vertices", () {
        expect(() => graph = new Graph(), initialized_properly);
        expect(graph.edges, isEmpty);
        expect(graph.vertices, isEmpty);
        expect(graph.is_empty, isTrue);
    });
    test("With Vertices Only", () {
        expect(() => graph = new Graph(vertices), initialized_properly);
        expect(graph.vertices, vertices);
        expect(graph.edges, isEmpty);
        expect(graph.is_empty, isFalse);
    });
    test("With Edges and Vertices", () {
        expect(() => graph = new Graph(vertices, edges), initialized_properly);
        expect(graph.vertices, vertices);
        expect(graph.edges, edges);
        expect(graph.is_empty, isFalse);
    });
}

addRemoveVertices() {
    Vertex v1 = new Vertex("v1");
    Vertex v2 = new Vertex("v2");

    test("Add Vertex", () {
        graph = new Graph();

        graph.add_vertex(v1);
        expect(graph.contains_vertex(v1), isTrue);
        expect(graph.vertices, [v1]);

        graph.add_vertex_if_absent(v1);
        expect(graph.vertices, [v1]);

        graph.add_vertex_if_absent(v2);
        graph.add_vertex_if_absent(v2);
        expect(graph.vertices, [v1, v2]);
    });
    test("Remove Vertex", () {
        graph = new Graph([v1, v2]);

        graph.remove_vertex(v1);
        expect(graph.contains_vertex(v1), isFalse);
        expect(graph.vertices, [v2]);

        graph.remove_vertex(v2);
        expect(graph.vertices, isEmpty);
        expect(graph.is_empty, isTrue);
    });
}

addRemoveEdges() {
    List vertices = generateVertices(3);
    Edge e1 = new Edge(vertices[0], vertices[1]);
    Edge e2 = new Edge(vertices[1], vertices[2]);

    test("Add Edges", () {
        graph = new Graph();

        graph.add_edge(e1);
        expect(graph.contains_edge(e1), isTrue);
        expect(graph.edges, [e1]);

        graph.add_edge(e1);
        expect(graph.edges, [e1]);

        graph.add_edge(e2);
        expect(graph.contains_edge(e2), isTrue);
        expect(graph.edges, [e1, e2]);
    });
    test("Remove Edges", () {

    });
}

testDegrees() {
    test("Out Vertices", (){});
    test("Out Edges", (){});
    test("Vertex Degrees", (){});
}

testCompleteness() {
    test("Is Complete", _testIsComplete);
    test("Add All Edges", _testAddAllEdges);
}
_testIsComplete() {}
_testAddAllEdges() {}

testRegularity() {
    test("Possible Regular Degrees", _testPossibleRegularDegrees);
    test("Is Regular", _testIsRegular);
    test("Add Regular Edges", _testAddingRegularEdges);
}
_testPossibleRegularDegrees() {}
_testIsRegular() {}
_testAddingRegularEdges() {
    int vertex_limit = 13;
    List vertices = generateVertices(vertex_limit);
    graph = new Graph();

    for (int vertex_count = 1; vertex_count < vertex_limit; vertex_count++) {
        graph.add_vertex(vertices[vertex_count]);
        _addEdgesForAllRegularDegrees();
    }
}
_addEdgesForAllRegularDegrees() {
    Map<int, int> regular_degrees = graph.possible_regular_degrees_and_edges;
    int vertex_count = graph.vertices.length;
    int edge_count(int degree) => regular_degrees[degree];

    for (int degree in regular_degrees.keys) {
        graph.add_regular_edges(degree);
        expect(graph.is_regular, isTrue);
        //expect(graph.edges.length, edge_count(degree));
    }
}


List<Vertex>
generateVertices(int vertex_count) {
    assert(vertex_count < VERTEX_NAMES.length);

    return new List.generate(vertex_count, (i) => new Vertex(VERTEX_NAMES[i]) );
}
List<Edge>
generateEdges(int edge_count) {
    assert(edge_count < VERTEX_NAMES.length-1);

    List vertices = generateVertices(edge_count+1);
    return new List.generate(edge_count, (i) => new Edge(vertices[i], vertices[i+1]));
}