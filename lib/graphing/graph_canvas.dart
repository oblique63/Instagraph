part of graphing;

class GraphCanvas {
    CanvasElement
      canvas;
    CanvasRenderingContext2D
      context;
    int
      width,
      height;
    Map
      vertex_tags = {},
      edge_tags = {};

    GraphCanvas(this.canvas) {
        width = canvas.width;
        height = canvas.height;
        context = canvas.context2D;

        context..fillStyle = "#fff"
               ..lineWidth = 1;
    }

    show_graph(Graph graph, Layout layout) {

        graph.edges.forEach((edge) => draw_edge(edge, layout));

        graph.vertices.forEach((vertex) => draw_vertex(vertex, layout));
    }

    draw_edge(Edge edge, Layout layout) {
        _line( layout.positionOf(edge.v1), layout.positionOf(edge.v2) );
    }

    draw_vertex(Vertex vertex, Layout layout, {int radius: 45, String color: 'yellow'}) {
        Coordinate position = layout.positionOf(vertex);
        _circle(position, radius, color);
        _text(position, vertex.label, '#000');
    }

    _line(Coordinate start, Coordinate end) {

    }

    _circle(Coordinate position, int radius, String color) {
        context..strokeStyle = color;
    }

    _text(Coordinate position, String text, String color) {

    }
}