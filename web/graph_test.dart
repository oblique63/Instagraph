import 'package:ThinkComplexity/graphing/graphing.dart';
import 'package:ThinkComplexity/think_complexity.dart';
import 'dart:html';


const int
GRAPH_VERTEX_COUNT = 7;

const List vertex_names = const
['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];


main() {
    List<Vertex> vertices =
            new List.generate(GRAPH_VERTEX_COUNT, (index) => new Vertex(vertex_names[index]) );

    Graph g = new Graph(vertices);
    g.add_all_edges();

    CircleLayout layout = new CircleLayout(g);

    CanvasElement canvas = document.querySelector("#stage");

    GraphCanvas graph_canvas = new GraphCanvas(canvas);

    graph_canvas.show_graph(g, layout);
}