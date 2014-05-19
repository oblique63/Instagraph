part of graphing;

class CircleLayout extends Layout {

    CircleLayout(Graph graph, [num radius = 300]) {
        List<Vertex> vertices = graph.vertices;

        num theta = (PI * 2) / vertices.length;

        for (int i=0; i < vertices.length; i++) {
            int x = (radius * cos(i * theta)).ceil();
            int y = (radius * sin(i * theta)).ceil();

            points[vertices[i]] = new Coordinate(x, y);
        }
    }

}