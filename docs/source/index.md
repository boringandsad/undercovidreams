---
layout: default
title: "sogni dall'isola"
---

<script>
  function rangemap(min, max, val) {
      return (val-min)/(max-min);
  }

  var div = d3.select("body")
      .append("div")
      .attr("class", "tooltip")
      .style("opacity", 0)
  
  var svg = d3.select("body")
      .append("svg")
      .attr("width", "100%")
      .attr("height", "100%")
      .style("border", "none")
      .style("background", "black")

  // Set the ranges
  var x = d3.scaleLinear().range([0, "100%"]);
  var y = d3.scaleLinear().range([0, "100%"]);

  var wordscoords={}
  
  d3.json("{{ site.baseurl }}/assets/data/words.json").then(
      function(data) {
          data.forEach(function(d) {
              d.word=d[0];
              d.x=d[1][0];
              d.y=d[1][1];
          });

          x.domain(d3.extent(data, function(d) {return d.x;}));
          y.domain(d3.extent(data, function(d) {return d.y;}));
          var dot=svg.selectAll("dot")	
              .data(data)
              .enter().append("circle")
          dot.attr("r", 4)
              .attr("cx", function(d) { return x(d.x); })		 
              .attr("cy", function(d) { return y(d.y); })
              .attr("fill", "#8888")
              .on("mouseover", function(event,d) {
                  div.transition()
                      .duration(200)
                      .style("opacity", .9);
                  div. html(d.word)
                      .style("left", (event.pageX) + "px")
                      .style("top", (event.pageY - 28) + "px");
              })					
              .on("mouseout", function(d) {		
                  div.transition()		
                      .duration(500)		
                      .style("opacity", 0);	
                      });

/*          d3.select("body")
              .selectAll("circle")
              .data(data)
              .enter().append("div")
              .style("width", function(d) { return x(d) + "px"; })
              .text(function(d) { return d; })
              .on("mouseover", function(d){tooltip.text(d); return tooltip.style("visibility", "visible");})
              .on("mousemove", function(){return tooltip.style("top", (d3.event.pageY-10)+"px").style("left",(d3.event.pageX+10)+"px");})
              .on("mouseout", function(){return tooltip.style("visibility", "hidden");});
          
  */        
          
      }
      )
</script>
