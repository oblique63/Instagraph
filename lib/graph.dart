part of think_complexity;

class Graph {
    Map< Vertex, Map<Vertex, Edge> >
      _graph_map = {};

    // TODO: maybe allow initialization with ONLY edges...
    Graph([ List<Vertex> vertices = const [], List<Edge> edges = const [] ]) {
        vertices.forEach(add_vertex);
        edges.forEach(add_edge);
    }

    List<Vertex> get
    vertices => _graph_map.keys.toList();

    int get
    vertex_count => _graph_map.keys.length;

    List<Edge> get
    edges {
        List<Edge> _edges = [];

        for (Vertex v1 in _graph_map.keys) {
            for (Vertex v2 in _graph_map[v1].keys) {

                if (!_edges.contains(_graph_map[v1][v2])) {
                    _edges.add(_graph_map[v1][v2]);
                }
            }
        }

        return _edges;
    }

    int get
    edge_count => edges.length;

    bool get
    is_regular =>
        vertices.every((vertex) => degree_of(vertex) == degree_of(vertices.first));

    bool get
    is_complete =>
        degree_of(vertices.first) == vertices.length-1 && is_regular;

    bool get
    is_empty => _graph_map.isEmpty;

    bool
    contains_vertex(Vertex vertex) => _graph_map.containsKey(vertex);

    bool
    _contains_reference(Vertex key, Vertex reference) {
        _graph_map[key].containsKey(reference);
    }

    List<Vertex>
    out_vertices(Vertex vertex) => _graph_map[vertex].keys.toList();

    List<Edge>
    out_edges(Vertex vertex) => _graph_map[vertex].values.toList();

    int
    degree_of(Vertex vertex) => out_edges(vertex).length;

    /// Works regardless of how Edges are directed/weighted
    bool
    vertices_are_connected(Vertex v1, Vertex v2) =>
        contains_vertex(v1) && _graph_map[v2].containsKey(v1);

    bool
    contains_edge(Edge edge) => vertices_are_connected(edge.v1, edge.v2);

    Edge
    get_edge(Vertex v1, Vertex v2) {
        if (vertices_are_connected(v1, v2)) {
            return _graph_map[v1][v2];
        }
        else return null;
    }

    void
    add_vertex(Vertex vertex) {
        _graph_map[vertex] = {};
    }

    void
    add_vertex_if_absent(Vertex vertex) {
        _graph_map.putIfAbsent(vertex, () => {});
    }

    void
    remove_vertex(Vertex vertex) {
        if (contains_vertex(vertex)) {
            vertices.forEach((v) => _graph_map[v].remove(vertex));
            _graph_map.remove(vertex);
        }
    }

    void
    add_edge(Edge edge) {
        Vertex v1 = edge.v1;
        Vertex v2 = edge.v2;

        add_vertex_if_absent(v1);
        add_vertex_if_absent(v2);

        _graph_map[v1][v2] = edge;
        _graph_map[v2][v1] = edge;
    }

    void
    remove_edge(Edge edge) {
        if (contains_edge(edge)) {
            _graph_map[edge.v1].remove(edge.v2);
            _graph_map[edge.v2].remove(edge.v1);
        }
    }

    void
    remove_all_edges() {
        _graph_map.values.forEach((Map<Vertex, Edge> map) => map.clear() );
    }

    void
    add_all_edges() {
       // Alternatively:
       //add_regular_edges(vertices.length-1);

        for (int i = 0; i < vertices.length-1; i++) {
            Vertex v1 = vertices[i];

            for (var j = i+1; j < vertices.length; j++) {
                Vertex v2 = vertices[j];

                add_edge(new Edge(v1, v2));
            }
        }
    }

    void
    add_regular_edges([int degree=2]) {
        if (!is_valid_regular_degree(degree))
            throw "Invalid degree";

        for (Vertex vertex in vertices) {
            _connect_to_nearest_neighbors(vertex, degree);

            if (degree.isOdd) { // vertex_count is also even (required to be valid)
                _connect_to_opposite_vertex(vertex);
            }
        }
    }

    bool
    is_valid_regular_degree(int degree) {
        return degree < vertex_count
            &&  degree > 0
            && !(degree.isOdd && vertex_count.isOdd);
    }

    void
    _connect_to_nearest_neighbors(Vertex vertex, int degree) {
        List<Vertex> neighbors = _find_neighbors_for(vertex, degree);

        neighbors.forEach((neighbor) => add_edge( new Edge(vertex, neighbor) ));
    }

    int
    _get_furthest_neighbor_distance(int degree) {
        int distance;
        if (degree.isOdd)
            distance = (degree-1) ~/ 2;
        else
            distance = degree ~/ 2;

        return distance;
    }

    List<Vertex>
    _find_neighbors_for(Vertex vertex, int degree) {
        int furthest_neighbor = _get_furthest_neighbor_distance(degree);
        int root = vertices.indexOf(vertex);
        List neighbors = [];

        for (int distance = furthest_neighbor; distance > 0; distance--) {
            int left_neighbor_index = root - distance;
            int right_neighbor_index = root + distance;

            if (left_neighbor_index < 0)
                left_neighbor_index += vertex_count;

            if (right_neighbor_index >= vertex_count)
                right_neighbor_index -= vertex_count;

            neighbors..add(vertices[left_neighbor_index])
                     ..add(vertices[right_neighbor_index]);
        }

        return neighbors;
    }

    void
    _connect_to_opposite_vertex(Vertex vertex) {
        int origin_index = vertices.indexOf(vertex);
        int opposite_distance = vertex_count ~/ 2;
        int opposite_index = origin_index + opposite_distance;

        if (opposite_index >= vertex_count)
            opposite_index -= vertex_count;

        add_edge( new Edge(vertex, vertices[opposite_index]) );
    }

    Map<int, int> get
    possible_regular_degrees_and_edges => possible_regular_degrees_and_edges_for(vertex_count);

    static Map<int, int>
    possible_regular_degrees_and_edges_for(int vertex_count) {
        int degree_step;
        Map valid_degrees = {};

        if (vertex_count > 1) {
            if (vertex_count.isEven)
                degree_step = 1;
            else
                degree_step = 2;

            for (int i = degree_step; i < vertex_count; i += degree_step) {
                valid_degrees[i] = 0; // calculate edge count
            }
        }

        return valid_degrees;
    }

    operator
    [](Vertex vertex) => _graph_map[vertex];

    String
    toString() => "Graph($_graph_map)";
}