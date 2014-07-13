import 'package:think_complexity/graphing/graphing.dart';
import 'package:think_complexity/think_complexity.dart';
import 'dart:html';

const List
    VERTEX_NAMES = const
        [ 'a','b','c','d','e','f','g','h','i','j','k','l','m',
          'n','o','p','q','r','s','t','u','v','w','x','y','z' ];

final List<OptionElement>
    VERTEX_COUNT_OPTIONS = new List.generate(VERTEX_NAMES.length, (i) => optionFor(i+1));

SelectElement
    vertices_select,
    degrees_select;
InputElement
    edge_color,
    complete_graph_checkbox;
ButtonElement
    generate_graph_button;
CanvasElement
    canvas;
GraphCanvas
    graph_canvas;

main() {
    vertices_select = document.querySelector("#vertex_count");
    degrees_select = document.querySelector("#regular_degrees");
    edge_color = document.querySelector("#edge_color");
    complete_graph_checkbox = document.querySelector("#complete_graph");
    generate_graph_button = document.querySelector("#generate_graph");
    canvas = document.querySelector("#stage");
    graph_canvas = new GraphCanvas(canvas);


    vertices_select..children = VERTEX_COUNT_OPTIONS
                   ..onChange.listen(onSetVertexCount);

    generate_graph_button.onClick.listen((_) => drawGraph(selectedVertexCount, selectedDegree));
}

int get
selectedVertexCount => int.parse(vertices_select.selectedOptions.first.value);

int get
selectedDegree => int.parse(degrees_select.selectedOptions.first.value);

String get
selectedEdgeColor => edge_color.value;

bool get
showCompleteGraph => complete_graph_checkbox.checked;

OptionElement
optionFor(option_content) => new OptionElement()..innerHtml = "$option_content"
                                                   ..value = "$option_content";

onSetVertexCount(_) {
    List degrees = Graph.possible_regular_degrees_and_edges_for(selectedVertexCount).keys.toList();
    List degree_options = new List.generate(degrees.length, (i) => optionFor(degrees[i]));

    degrees_select.children = degree_options;
}

drawGraph(int vertex_count, int regular_degrees) {
    List<Vertex> vertices = new List.generate(vertex_count, (i) => new Vertex(VERTEX_NAMES[i]) );
    Graph graph = new Graph(vertices);
    CircleLayout layout = new CircleLayout(graph);

    if (showCompleteGraph) {
        graph.add_all_edges();
    }

    graph_canvas.clear();

    if (regular_degrees == 0) {
        graph_canvas.show_vertices(graph, layout);
    }
    else {
        graph_canvas.show_edges(graph, layout)
        .then((_) {
            graph..remove_all_edges()
                 ..add_regular_edges(regular_degrees);

            return graph_canvas.highlight_edges(graph.edges, layout, selectedEdgeColor);
        })
        .then((_) {
            graph_canvas.show_vertices(graph, layout);
        });
    }
}