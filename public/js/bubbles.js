var r = 960,
format = d3.format(",d"),
fill = d3.scale.category20c();

var bubble = d3.layout.pack().sort(null).size([r, r]);

var vis = d3.select("#chart").append("svg:svg")
            .attr("width", r)
            .attr("height", r)
            .attr("class", "bubble");

d3.json(window.location +  "/committers.json", function(json) {
  var node = vis.selectAll("g.node")
    .data(bubble(json)
    .filter(function(d) { return !d.children; }))
    .enter().append("svg:g")
    .attr("class", "node")
    .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });

  node.append("svg:title")
    .text(function(d) { return d.data.author + ": " + format(d.total); });

  node.append("svg:circle")
    .attr("r", function(d) { return d.r; })
    .style("fill", function(d) { return fill(d.data.author); });

  node.append("svg:text")
    .attr("text-anchor", "middle")
    .attr("dy", ".3em")
    .text(function(d) { return d.data.author.substring(0, d.r / 3); });
});
