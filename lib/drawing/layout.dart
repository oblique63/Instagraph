part of instagraph.drawing;

/// Handles the 2D spatial layout of Vertices in a Graph
abstract class Layout {
    Map<Vertex, Coordinate> points = {};

    Coordinate
    positionOf(Vertex vertex) => points[vertex];

    num
    distanceBetween(Vertex v1, Vertex v2) {
        Coordinate c1 = positionOf(v1);
        Coordinate c2 = positionOf(v2);

        int dx = c1.x - c2.x;
        int dy = c1.y - c2.y;

        return sqrt( pow(dx, 2) + pow(dy, 2) );
    }

    List<Vertex>
    sortByDistance(Vertex vertex, List<Vertex> others) {
        List<List> temp = others.map((v) => [distanceBetween(vertex, v), v] );

        temp.sort((v1, v2) => v1[0] - v2[0]);

        return temp.map((v) => v[1]);
    }

    /// Only needs to be called when a Graph's Vertex count has changed
    void
    recalculate(Graph graph);
}

class Coordinate {
    int x, y;

    Coordinate(this.x, this.y);

    Coordinate
    offsetBy(int x_offset, int y_offset) => new Coordinate(x+x_offset, y+y_offset);
}