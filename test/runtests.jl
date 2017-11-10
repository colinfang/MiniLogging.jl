using Base.Test
using MiniLogging
using MiniLogging.Hierarchy
using MiniLogging.Hierarchy: Ancestors

@test collect(Ancestors("")) == []
@test collect(Ancestors("a")) == [""]
@test collect(Ancestors("a.bb.ccc")) == ["a.bb", "a", ""]
@test collect(Ancestors(".a.bb.ccc")) == [".a.bb", ".a", ""]
@test collect(Ancestors("❤.❤❤.❤❤❤")) == ["❤.❤❤", "❤" , ""]
@test_throws ErrorException collect(Ancestors("a.b.cc."))
@test_throws ErrorException collect(Ancestors("a.b..cc"))


t = Tree()
push!(t, "a.b.c")
@test parent_node(t, "a.b.c") == ""
push!(t, "a.b.c")
@test parent_node(t, "a.b.c") == ""
push!(t, "a.b")
@test parent_node(t, "a.b") == ""
@test parent_node(t, "a.b.c") == "a.b"
push!(t, "a.b.c.d")
@test parent_node(t, "a.b.c.d") == "a.b.c"
push!(t, "a.b.c.d2")
@test parent_node(t, "a.b.c.d2") == "a.b.c"
push!(t, "a.b.c.d.❤")
@test parent_node(t, "a.b.c.d.❤") == "a.b.c.d"
push!(t, "a.b.❤.d")
@test parent_node(t, "a.b.❤.d") == "a.b"
push!(t, "a")
@test parent_node(t, "a") == ""
push!(t, ".a.b")
@test parent_node(t, ".a.b") == ""
push!(t, ".a.b.c")
@test parent_node(t, ".a.b.c") == ".a.b"
push!(t, "")
@test parent_node(t, "") == ""


basic_config(MiniLogging.INFO)
logger = get_logger("a.b")
@info(logger, "Hello", " world", )
@debug(logger, "Hello", " world", error("no error"))

MiniLogging.define_new_level(:trace, 25, :yellow)
@trace(logger, "Hello", " world")
