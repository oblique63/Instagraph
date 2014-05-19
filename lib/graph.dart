part of think_complexity;

class Graph {
    Map< Vertex, Map<Vertex, Edge> >
      _graph = {};

    Graph([ List<Vertex> vertices = const [], List<Edge> edges = const [] ]) {
        vertices.forEach(add_vertex);
        edges.forEach(add_edge);
    }

    List<Vertex> get
    vertices => _graph.keys.toList();

    List<Edge> get
    edges {
        List<Edge> edges = [];

        for (Vertex v1 in _graph.keys) {
            for (Vertex v2 in _graph[v1].keys) {
                if (!edges.contains(_graph[v1][v2])) {
                    edges.add(_graph[v1][v2]);
                }
            }
        }

        return edges;
    }

    bool get
    is_regular =>
        vertices.every((vertex) => degree_of(vertex) == degree_of(vertices.first));

    bool get
    is_complete =>
        degree_of(vertices.first) == vertices.length-1 && is_regular;

    List<Vertex>
    out_vertices(Vertex vertex) => _graph[vertex].keys.toList();

    List<Edge>
    out_edges(Vertex vertex) => _graph[vertex].values.toList();

    int
    degree_of(Vertex vertex) => out_edges(vertex).length;

    Edge
    get_edge(Vertex v1, Vertex v2) {
        if ( _graph.containsKey(v1)
        &&   _graph[v1].containsKey(v2) ) {
            return _graph[v1][v2];
        }
        else {
            return null;
        }
    }

    void
    add_vertex(Vertex vertex) {
        _graph[vertex] = {};
    }

    void
    add_edge(Edge edge) {
        Vertex v1 = edge.v1;
        Vertex v2 = edge.v2;

        if (!_graph.containsKey(v1)) {
            add_vertex(v1);
        }
        if (!_graph.containsKey(v2)) {
            add_vertex(v2);
        }

        _graph[v1][v2] = edge;
        _graph[v2][v1] = edge;
    }

    void
    remove_edge(Edge edge) {
        if (_graph.containsKey(edge.v1)
        &&  _graph[edge.v1].containsKey(edge.v2)) {

            _graph[edge.v1].remove(edge.v2);
            _graph[edge.v2].remove(edge.v1);
        }
    }

    void
    add_all_edges() {
        List<Vertex> vertex_list = _graph.keys.toList(growable: false);

        for (int i = 0; i < vertex_list.length-1; i++) {
            Vertex v1 = vertex_list[i];

            for (var j = i+1; j < vertex_list.length; j++) {
                Vertex v2 = vertex_list[j];

                add_edge(new Edge(v1, v2));
            }
        }

        // Alternatively:
        //add_regular_edges(vertices.length-1);
    }

    void
    add_regular_edges([int degree=2]) {
        var vertex_list = _graph.keys.toList();
        var vertex_count = vertex_list.length;

        if (degree > vertex_count-1
        || (degree.isOdd && vertex_count.isOdd)
        ||  degree <= 0)
            throw "Invalid degree";

        if (degree > 1) {
            //add_edge( new Edge(vertex_list.last, vertex_list.first) );
        }

        for (int i = 0; i < vertex_count; i++) {
            Vertex v1 = vertex_list[i];

            var degree_count = degree_of(v1);

            var start_step, increment_by;
            if (vertex_count.isEven && degree.isOdd) {
                start_step = 1;
                increment_by = 1;
            }
            else if (vertex_count.isEven && degree.isEven) {
                start_step = 1;
                increment_by = 2;
            }
            else if (vertex_count.isOdd && degree == vertex_count-1) {
                start_step = 1;
                increment_by = 1;
            }
            else if (vertex_count.isOdd && degree.isEven) {
                start_step = 3;
                increment_by = 2;
            }

            //if (degree == vertex_count-1)
            //    increment_by = 1;
            //else
            //    increment_by = 2;

            for (int j = i+start_step; degree_count < degree; j+=increment_by) {
                Vertex v2;

                if (j >= vertex_count) {
                    if (j/vertex_count >= 2) break;
                    //print("i = $i, j = $j = ${j%vertex_count}");

                    v2 = vertex_list[j-vertex_count];
                }
                else {
                        v2 = vertex_list[j];
                    }

                    if (degree_of(v2) < degree && v1 != v2) {
                        add_edge(new Edge(v1, v2));
                        degree_count += 1;
                    }
                }
            //}
        }
    }

    List<int> get
    possible_regular_degrees {
        int graph_vertices = vertices.length;

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

    operator
    [](Vertex vertex) => _graph[vertex];

    String
    toString() => "$_graph";
}