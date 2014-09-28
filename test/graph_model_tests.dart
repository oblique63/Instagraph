import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'package:instagraph/models/models.dart';

const List
VERTEX_NAMES = const
    [ 'a','b','c','d','e','f','g','h','i','j','k','l','m',
      'n','o','p','q','r','s','t','u','v','w','x','y','z' ];

Graph graph;

main() {
    useVMConfiguration();

    group("Graph Initialization:", testGraphInitializations);
    group("Vertices:", testVertices);
    group("Edges:", testEdges);
    group("Vertex Degrees:", testDegrees);
    group("Graph Completeness:", testCompleteness);
    group("Graph Regularity:", testRegularity);
}

testGraphInitializations() {
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

testVertices() {
    Vertex v1 = new Vertex("v1");
    Vertex v2 = new Vertex("v2");

    test("Add Vertex", () {
        graph = new Graph();

        graph.add_vertex(v1);
        expect(graph.contains_vertex(v1), isTrue);
        expect(graph.vertices, [v1]);
        equals(graph.vertex_count, 1);

        graph.add_vertex_if_absent(v1);
        expect(graph.vertices, [v1]);

        graph..add_vertex_if_absent(v2)
             ..add_vertex_if_absent(v2);
        expect(graph.vertices, [v1, v2]);
        equals(graph.vertex_count, 2);
    });
    test("Remove Vertex", () {
        graph = new Graph([v1, v2]);

        graph.remove_vertex(v1);
        expect(graph.contains_vertex(v1), isFalse);
        expect(graph.vertices, [v2]);

        graph.remove_vertex(v2);
        expect(graph.vertices, isEmpty);
        equals(graph.vertex_count, 0);
        expect(graph.is_empty, isTrue);

        graph..add_vertex(v1)
             ..add_vertex(v2)
             ..clear();
        expect(graph.is_empty, isTrue);
    });
}

testEdges() {
    List vertices = generateVertices(4);
    int max_possible_edges = 6;
    Edge e1 = new Edge(vertices[0], vertices[1]);
    Edge e2 = new Edge(vertices[1], vertices[2]);

    test("Add Edges", () {
        graph = new Graph();

        graph.add_edge(e1);
        equals(graph.edge_count, 1);
        expect(graph.edges, [e1]);

        graph.add_edge(e1);
        expect(graph.edges, [e1]);

        graph.add_edge(e2);
        equals(graph.edge_count, 2);
        expect(graph.edges, [e1, e2]);

        graph.add_all_edges();
        equals(graph.edge_count, max_possible_edges);
    });
    test("Get Edges", () {
        graph = new Graph(vertices, [e1]);

        expect(graph.contains_edge(e1), isTrue);
        expect(graph.contains_edge(e2), isFalse);
        expect(graph.vertices_are_connected(e1.v1, e1.v2), isTrue);
        expect(graph.get_edge(e1.v1, e1.v2), e1);
    });
    test("Remove Edges", () {
        graph = new Graph(vertices, [e1, e2]);

        graph.remove_edge(e1);
        expect(graph.contains_edge(e1), isFalse);
        expect(graph.edges, [e2]);

        graph..add_all_edges()
             ..remove_all_edges();
        equals(graph.edge_count, 0);
        expect(graph.is_empty, isFalse, reason: "Graph should still have vertices");
    });
}

testDegrees() {
    test("Out Vertices", (){});
    test("Out Edges", (){});
    test("Vertex Degrees", (){});
}

testCompleteness() {
    List vertices = generateVertices(4);
    int max_possible_edges = 6;
    Edge e1 = new Edge(vertices[0], vertices[1]);
    Edge e2 = new Edge(vertices[1], vertices[2]);

    test("Is Complete", () {
        graph = new Graph(vertices, [e1]);
        expect(graph.is_complete, isFalse);

        graph.add_edge(e2);
        expect(graph.is_complete, isFalse);

        graph.add_all_edges();
        expect(graph.is_complete, isTrue);
        equals(graph.edge_count, max_possible_edges);
    });
}

testRegularity() {
    test("Possible Regular Degrees", _testPossibleRegularDegrees);
    test("Regular Edge Count Estimation", _testRegularEdgeCountEstimation);
    test("Is Regular", _testIsRegular);
    test("Add Valid Regular Edges", _testAddingValidRegularEdges);
    test("Add Invalid Regular Edges", _testAddingInvalidRegularEdges);
}

_testPossibleRegularDegrees() {
    // TODO
}

_testRegularEdgeCountEstimation() {
    // TODO
}

_testIsRegular() {
    // TODO
}

_testAddingValidRegularEdges() {
    int vertex_limit = VERTEX_NAMES.length ~/ 2;
    List vertices = generateVertices(vertex_limit);
    graph = new Graph();

    for (int vertex_count = 1; vertex_count < vertex_limit; vertex_count++) {
        graph.add_vertex(vertices[vertex_count]);
        _addEdgesForAllRegularDegrees();
    }
}

_addEdgesForAllRegularDegrees() {
    List<int> regular_degrees = graph.possible_regular_degrees;

    for (int degree in regular_degrees) {
        graph.remove_all_edges();
        graph.add_regular_edges(degree);

        expect(graph.is_regular, isTrue);
        expect(graph.edge_count, Graph.regular_edge_count_for(graph.vertex_count, degree));
    }
}

_testAddingInvalidRegularEdges() {
    int vertex_count = 5;
    List vertices = generateVertices(vertex_count);

    graph = new Graph(vertices);

    expect(() => graph.add_regular_edges(vertex_count), throws,
        reason: "Vertex degree must be smaller than vertex_count");
    expect(() => graph.add_regular_edges(0), throws,
        reason: "Vertex degree must be greater than 0");
    expect(() => graph.add_regular_edges(3), throws,
        reason: "Vertex degree must be even for odd vertex_count values");
}


List<Vertex>
generateVertices(int vertex_count) {
    expect(vertex_count < VERTEX_NAMES.length, isTrue);

    return new List.generate(vertex_count, (i) => new Vertex(VERTEX_NAMES[i]) );
}
List<Edge>
generateEdges(int edge_count) {
    expect(edge_count < VERTEX_NAMES.length-1, isTrue);

    List vertices = generateVertices(edge_count+1);
    return new List.generate(edge_count, (i) => new Edge(vertices[i], vertices[i+1]));
}