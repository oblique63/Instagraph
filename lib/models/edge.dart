part of instagraph;

class Edge {
    List<Vertex>
      _vertices;

    Edge(Vertex vertex_1, Vertex vertex_2) {
        _vertices = [vertex_1, vertex_2];
    }

    Vertex
    operator [](int vertex_index) => _vertices[vertex_index];

    Vertex get
    v1 => _vertices[0];

    Vertex get
    v2 => _vertices[1];

    int get
    hashCode => int.parse("${v1.hashCode}${v2.hashCode}");

    String
    toString() => "Edge(${_vertices[0]}, ${_vertices[1]})";

    // Order of vertices matters for the moment, but maybe it shouldn't (unless Edge is Directed)...
    bool operator
    == (Edge other) => other._vertices == this._vertices;
}

// TODO: eventually support Directed and Weighted Edges