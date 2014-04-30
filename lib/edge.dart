part of think_complexity;

class Edge {
    List<Vertex>
      _vertices;
    bool
      directed = false;

    Edge(Vertex vertex_1, Vertex vertex_2, {this.directed}) {
        _vertices = [vertex_1, vertex_2];
    }

    Vertex
    operator [](int vertex_index) => _vertices[vertex_index];

    Vertex get
    v1 => _vertices[0];

    Vertex get
    v2 => _vertices[1];

    String
    toString() => "Edge(${_vertices[0]}, ${_vertices[1]})";
}

class WeightedEdge extends Edge {
    num weight = 0;
    WeightedEdge(Vertex vertex_1, Vertex vertex_2, this.weight, {this.directed}) :
      super(vertex_1, vertex_2, directed: directed);
}