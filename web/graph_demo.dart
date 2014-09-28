import 'package:instagraph/instagraph.dart';
import 'dart:html';

const List
    VERTEX_NAMES = const
        [ 'a','b','c','d','e','f','g','h','i','j','k','l','m',
          'n','o','p','q','r','s','t','u','v','w','x','y','z' ];

SelectElement
    vertices_select,
    degrees_select;
InputElement
    edge_color_picker,
    complete_graph_checkbox,
    hide_vertices_checkbox;
ButtonElement
    generate_graph_button;
CanvasElement
    canvas;
GraphCanvas
    graph_canvas;

main() {
    _initSelectors();

    graph_canvas = new GraphCanvas(canvas);

    List vertex_count_options = new List.generate(VERTEX_NAMES.length, (i) => _createOptionFor(i+1));

    vertices_select..children = vertex_count_options
                   ..onChange.listen(onSetVertexCount);

    generate_graph_button.onClick.listen((_) => drawRegularGraph(selectedVertexCount, selectedDegree));
}

int get
selectedVertexCount => int.parse(vertices_select.selectedOptions.first.value);

int get
selectedDegree => int.parse(degrees_select.selectedOptions.first.value);

String get
selectedEdgeColor => edge_color_picker.value;

bool get
showCompleteGraph => complete_graph_checkbox.checked;

bool get
showVertices => !hide_vertices_checkbox.checked;

onSetVertexCount(_) {
    List degrees = Graph.possible_regular_degrees_for(selectedVertexCount);
    List degree_options = new List.generate(degrees.length, (i) => _createOptionFor(degrees[i]));

    degrees_select.children = degree_options;
}

drawRegularGraph(int vertex_count, int degree) {
    List<Vertex> vertices = new List.generate(vertex_count, (i) => new Vertex(VERTEX_NAMES[i]) );
    Graph graph = new Graph(vertices);
    CircleLayout layout = new CircleLayout(graph);

    if (showCompleteGraph) {
        graph.add_all_edges();
    }

    graph_canvas.clear();

    if (degree == 0 && showVertices) {
        graph_canvas.show_vertices(graph, layout);
    }
    else {
        graph_canvas.show_edges(graph, layout) // in case of showCompleteGraph first
        .then((_) {
            graph..remove_all_edges()
                 ..add_regular_edges(degree);

            return graph_canvas.highlight_edges(graph.edges, layout, selectedEdgeColor);
        })
        .then((_) {
            if (showVertices) {
                graph_canvas.show_vertices(graph, layout);
            }
        });
    }
}

_initSelectors() {
    vertices_select = document.querySelector("#vertex_count");
    degrees_select = document.querySelector("#regular_degrees");
    edge_color_picker = document.querySelector("#edge_color");
    complete_graph_checkbox = document.querySelector("#complete_graph");
    hide_vertices_checkbox = document.querySelector("#hide_vertices");
    generate_graph_button = document.querySelector("#generate_graph");
    canvas = document.querySelector("#stage");
}

_createOptionFor(option_content) =>
    new OptionElement()..innerHtml = "$option_content"
                         ..value = "$option_content";