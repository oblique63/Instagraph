part of graphing;

class GraphCanvas {
    CanvasRenderingContext2D
      context;
    int
      width,
      height,
      // offset because Layout uses negative coordinates
      x_offset,
      y_offset;

    GraphCanvas(CanvasElement canvas) {
        width = canvas.width;
        height = canvas.height;
        x_offset = (width/2).ceil();
        y_offset = (height/2).ceil();
        context = canvas.context2D;

        context..fillStyle = "#fff"
               ..lineWidth = 1;
    }

    show_graph(Graph graph, Layout layout) {

        graph.edges.forEach((edge) => draw_edge(edge, layout));

        graph.vertices..forEach((vertex) => draw_vertex(vertex, layout))
                      ..forEach((vertex) => draw_label(vertex, layout));
    }

    draw_edge(Edge edge, Layout layout) {
        Coordinate start = layout.positionOf(edge.v1).offset(x_offset, y_offset);
        Coordinate end = layout.positionOf(edge.v2).offset(x_offset, y_offset);

        _line(start, end);
    }

    draw_vertex(Vertex vertex, Layout layout, {int radius: 25, String color: 'yellow'}) {
        Coordinate position = layout.positionOf(vertex).offset(x_offset, y_offset);
        _circle(position, radius, color);

    }

    draw_label(Vertex vertex, Layout layout, {String color: '#d59'}) {
        Coordinate position = layout.positionOf(vertex).offset(x_offset, y_offset);
        _text(position, vertex.label, color);
    }


    _line(Coordinate start, Coordinate end, [String color = '#000']) {
        context..lineWidth = 3
               ..strokeStyle = color
               ..moveTo(start.x, start.y)
               ..lineTo(end.x, end.y)
               ..stroke();
    }

    _circle(Coordinate position, int radius, [String color = '#000']) {
        context..fillStyle = color
               ..moveTo(position.x, position.y)
               ..arc(position.x, position.y, radius, 0, 2*PI)
               ..stroke()
               ..fill();
    }

    _text(Coordinate position, String text, [String color = '#000']) {
        context..fillStyle = color
               ..font = 'italic 20pt Calibri'
               ..textAlign = "center"
               ..textBaseline = "middle"
               ..fillText(text, position.x, position.y);
    }
}