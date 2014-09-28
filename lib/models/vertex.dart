part of instagraph.models;

class Vertex {
    String label = '';

    Vertex([this.label]);

    String
    toString() => "Vertex($label)";

    get
    hashCode =>
        int.parse(label.codeUnits.join());

    bool operator
    == (Vertex other) => this.toString() == other.toString();
}