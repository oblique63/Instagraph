part of graphing;

class CircleLayout extends Layout {

    CircleLayout(Graph graph, [num radius = 9]) {
        List<Vertex> vertices = graph.vertices;

        num theta = (PI * 2) / vertices.length;

        for (int i=0; i < vertices.length; i++) {
            num x = radius * cos(i * theta);
            num y = radius * sin(i * theta);

            points[vertices[i]] = new Coordinate(x, y);
        }
    }

}