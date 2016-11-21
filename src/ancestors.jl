immutable Ancestors
    node::String

    function Ancestors(node::String)
        if endswith(node, '.')
            error("Invalid node $node - Cannot end with `.`")
        end
        new(node)
    end
end

Base.start(x::Ancestors) = endof(x.node)

function Base.next(a::Ancestors, state)
    node = a.node
    i = rsearch(node, '.', state)
    if i > 1
        state = prevind(node, i)
        if node[state] == '.'
            error("Invalid node $node - Cannot have `..`")
        end
        node[1:state], state
    else
        "", 0
    end
end

Base.done(::Ancestors, state) = state < 1
Base.iteratorsize(::Type{Ancestors}) = Base.SizeUnknown()
Base.eltype(::Type{Ancestors}) = String

is_ancestor_or_self(ancestor::String, descendant::String) = startswith(descendant, ancestor)
