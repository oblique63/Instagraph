import 'package:ThinkComplexity/graphing/graphing.dart';
import 'package:ThinkComplexity/think_complexity.dart';
import 'dart:html';


const int
GRAPH_VERTEX_COUNT = 6;

const List
VERTEX_NAMES = const
    [ 'a','b','c','d','e','f','g','h','i','j','k','l','m',
      'n','o','p','q','r','s','t','u','v','w','x','y','z' ];

List<Vertex>
vertices =
    new List.generate(GRAPH_VERTEX_COUNT, (i) => new Vertex(VERTEX_NAMES[i]) );


main() {
        Graph graph = new Graph(vertices);

        CanvasElement canvas = document.querySelector("#stage");
        GraphCanvas graph_canvas = new GraphCanvas(canvas);

        graph.add_all_edges();
        CircleLayout layout = new CircleLayout(graph);

        graph_canvas.show_edges(graph, layout)
        .then((_) {
            graph..remove_all_edges()
                 ..add_regular_edges(4);

            return graph_canvas.highlight_edges(graph.edges, layout, 'red');
        })
        .then((_) {
            graph_canvas.show_vertices(graph, layout);
        });
}