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
    num
      vertex_radius = 22,
      edge_width = 2.5;
    String
      edge_color = '#000',
      vertex_color = 'yellow',
      label_color = '#937',
      label_font = 'italic 18pt Calibri',
      canvas_background = "#fff";

    GraphCanvas(CanvasElement canvas) {
        width = canvas.width;
        height = canvas.height;
        x_offset = (width/2).ceil();
        y_offset = (height/2).ceil();
        context = canvas.context2D;
    }

    Future
    clear() => new Future(() => context.clearRect(0, 0, width, height));

    Future
    show_graph(Graph graph, Layout layout) {
        return clear().then((_) =>
                show_edges(graph, layout).then((_) =>
                show_vertices(graph, layout)).then((_) =>
                show_labels(graph, layout)));
    }

    Future
    show_edges(Graph graph, Layout layout) {
        return Future.forEach(graph.edges, (edge) => draw_edge(edge, layout, color: edge_color));
    }

    Future
    show_vertices(Graph graph, Layout layout, {bool labels: true}) {
        return
        Future.forEach(graph.vertices, (vertex) => draw_vertex(vertex, layout, radius: vertex_radius, fill_color: vertex_color))
        .then((_) {
            if (labels) {
                return show_labels(graph, layout);
            }
        });
    }

    Future
    show_labels(Graph graph, Layout layout) {
        return Future.forEach(graph.vertices, (vertex) => draw_label(vertex, layout, color: label_color));
    }


    Future
    highlight_edges(List<Edge> edges, Layout layout, String color) {
        return Future.forEach(edges, (edge) => draw_edge(edge, layout, color: color));
    }

    Future
    highlight_vertices(List<Vertex> vertices, Layout layout, String outline_color, [String fill_color = 'yellow']) {
        return Future.forEach(vertices, (vertex) => draw_vertex(vertex, layout, outline_color: outline_color, fill_color: fill_color));
    }


    Future
    draw_edge(Edge edge, Layout layout, {String color: '#000'}) {
        Coordinate start = layout.positionOf(edge.v1).offsetBy(x_offset, y_offset);
        Coordinate end = layout.positionOf(edge.v2).offsetBy(x_offset, y_offset);

        return _line(start, end, color);
    }

    Future
    draw_vertex(Vertex vertex, Layout layout, {int radius: 25, String fill_color: 'yellow', String outline_color: 'black'}) {
        Coordinate position = layout.positionOf(vertex).offsetBy(x_offset, y_offset);
        return _circle(position, radius, fill_color, outline_color);

    }

    Future
    draw_label(Vertex vertex, Layout layout, {String color: '#d59'}) {
        Coordinate position = layout.positionOf(vertex).offsetBy(x_offset, y_offset);
        return _text(position, vertex.label, color);
    }


    Future
    _line(Coordinate start, Coordinate end, [String color = '#000']) {
        return new Future(() {
            context..beginPath()
                   ..moveTo(start.x, start.y)
                   ..lineWidth = edge_width
                   ..strokeStyle = color
                   ..lineTo(end.x, end.y)
                   ..stroke()
                   ..closePath();
        });
    }

    Future
    _circle(Coordinate position, int radius, [String fill_color = '#000', String line_color = '#000']) {
        return new Future(() {
            context..moveTo(position.x, position.y)
                   ..beginPath()
                   ..fillStyle = fill_color
                   ..strokeStyle = line_color
                   ..arc(position.x, position.y, radius, 0, 2*PI)
                   ..stroke()
                   ..fill()
                   ..closePath();
        });
    }

    Future
    _text(Coordinate position, String text, [String color = '#000']) {
        return new Future(() {
            context..beginPath()
                   ..fillStyle = color
                   ..font = label_font
                   ..textAlign = "center"
                   ..textBaseline = "middle"
                   ..fillText(text, position.x, position.y)
                   ..closePath();
        });
    }
}