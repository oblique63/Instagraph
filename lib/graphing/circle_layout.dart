part of graphing;

class CircleLayout extends Layout {
    int radius;

    CircleLayout(Graph graph, {int radius: 300}) {
        this.radius = radius;
        recalculate(graph);
    }

    recalculate(Graph graph) {
        List<Vertex> vertices = graph.vertices;

        /// Angle difference between vertices
        num theta = (PI * 2) / vertices.length;

        for (int i=0; i < vertices.length; i++) {
            int x = (radius * -cos(i * theta)).ceil();
            int y = (radius * -sin(i * theta)).ceil();

            points[vertices[i]] = new Coordinate(x, y);
        }
    }
}