HTMLWidgets.widget({
  name: 'geocard',
  type: 'output',
  factory: function(el, width, height) {
    return {
      renderValue: function(x) {
        el.innerHTML = x.html;
        var factor = width / 500;

        // add csv data to link
        var link = el.getElementsByClassName("card-csv")[0];
        var csvContent = "data:text/csv;charset=utf-8,date,cases,deaths,source\n";
        csvContent += x.dat.map(e => e.date + "," + e.cases + "," + e.deaths + "," + e.source).join("\n");
        link.setAttribute("href", encodeURI(csvContent));
        link.setAttribute("download", x.plot_id + ".csv");

        var dt = el.getElementsByClassName("data-table")[0];
        dt.setAttribute("style", `transform: scale(${factor},${factor}) translateX(-50%); transform-origin: top left;`);
        var hgt = dt.offsetHeight * factor
        el.getElementsByClassName("plot-image")[0].setAttribute("style", "top: " + (dt.offsetTop + hgt + 5) + "px;");
        x.spec.width = width - 10;
        x.spec.height = height - hgt - dt.offsetTop - 20;
        function makePlot(variable, source, yaxis) {
          var mxs;
          if (source === 'weekly') {
            x.spec.data.values = x.wdat;
            mxs = x.wmaxes;
          } else {
            x.spec.data.values = x.dat;
            mxs = x.maxes;
          }
          x.spec.layer[0].encoding.y.field = variable;
          x.spec.layer[1].transform[0].value = variable;
          if (yaxis === 'log') {
            x.spec.layer[0].encoding.y.scale.type = 'log';
            if (x.y_log_domain === null) {
              x.spec.layer[0].encoding.y.scale.domain = [1, mxs[variable]];
            } else {
              x.spec.layer[0].encoding.y.scale.domain = [
                x.y_log_domain[source].min[variable],
                x.y_log_domain[source].max[variable]
              ];
            }
          } else {
            x.spec.layer[0].encoding.y.scale.type = 'linear';
            x.spec.layer[0].encoding.y.scale.domain = [0, mxs[variable]];
          }
          // console.log(JSON.stringify(x.spec))
          vegaEmbed('#' + x.plot_id, x.spec, { "actions": false });
          // .then(function(res) {
          //   window['myplot'] = res;
          //   // res.view.remove('main_data', function(x) { return true;}).run()
          //   // "renderer": "svg"
          // });
        }
        var lft = 82;
        var ysel = el.getElementsByClassName('yvar-selector')[0];
        ysel.setAttribute("style", "left: " + (lft) + "px; top: " + (dt.offsetTop + hgt + 2) + "px;");
        var agg = el.getElementsByClassName('agg-selector')[0];
        agg.setAttribute("style", "left: " + (lft + 106) + "px; top: " + (dt.offsetTop + hgt + 2) + "px;");
        var yax = el.getElementsByClassName('yax-selector')[0];
        yax.setAttribute("style", "left: " + (lft + 106 + 63) + "px; top: " + (dt.offsetTop + hgt + 2) + "px;");
        var hdvar = el.getElementsByClassName('hdvar-selector')[0];
        if (window.cur_trscope_vega_y_var !== undefined) {
          ysel.value = cur_trscope_vega_y_var;
        }
        if (window.cur_trscope_vega_dat !== undefined) {
          agg.value = cur_trscope_vega_dat;
        }
        if (window.cur_trscope_vega_yax !== undefined) {
          yax.value = cur_trscope_vega_yax;
        }
        if (window.cur_trscope_selected_hdvar !== undefined) {
          hdvar.value = cur_trscope_selected_hdvar;
        }
        ysel.addEventListener('change', function(e) {
          window.cur_trscope_vega_y_var = e.target.value;
          var event = new Event('passivechange', {
            bubbles: true,
            cancelable: true,
          });
          var els = document.getElementsByClassName('yvar-selector');
          for (var i = 0; i < els.length; i++) {
            els[i].value = e.target.value;
            els[i].dispatchEvent(event);
          }
          ysel.blur();
        });
        ysel.addEventListener('passivechange', function(e) {
          makePlot(ysel.value, agg.value, yax.value);
        });

        agg.addEventListener('change', function(e) {
          window.cur_trscope_vega_dat = e.target.value;
          var event = new Event('passivechange', {
            bubbles: true,
            cancelable: true,
          });
          var els = document.getElementsByClassName('agg-selector');
          for (var i = 0; i < els.length; i++) {
            els[i].value = e.target.value;
            els[i].dispatchEvent(event);
          }
          agg.blur();
        });
        agg.addEventListener('passivechange', function(e) {
          makePlot(ysel.value, agg.value, yax.value);
        });

        yax.addEventListener('change', function(e) {
          window.cur_trscope_vega_yax = e.target.value;
          var event = new Event('passivechange', {
            bubbles: true,
            cancelable: true,
          });
          var els = document.getElementsByClassName('yax-selector');
          for (var i = 0; i < els.length; i++) {
            els[i].value = e.target.value;
            els[i].dispatchEvent(event);
          }
          yax.blur();
        });
        yax.addEventListener('passivechange', function(e) {
          makePlot(ysel.value, agg.value, yax.value);
        });

        hdvar.addEventListener('change', function(e) {
          window.cur_trscope_selected_hdvar = e.target.value;
          var event = new Event('passivechange', {
            bubbles: true,
            cancelable: true,
          });
          var els = document.getElementsByClassName('hdvar-selector');
          for (var i = 0; i < els.length; i++) {
            els[i].value = e.target.value;
            els[i].dispatchEvent(event);
          }
          hdvar.blur();          
        })
        hdvar.addEventListener('passivechange', function(e) {
          var els = el.getElementsByClassName('data-row-data');
          for (var ii = 0; ii < els.length; ii++) {
            els[ii].classList.add('hidden');
          }
          var els2 = el.getElementsByClassName('data-row-' + e.target.value);
          for (var ii = 0; ii < els.length; ii++) {
            els2[ii].classList.remove('hidden');
          }
        })

        var curvar = window.cur_trscope_vega_y_var;
        if (curvar === undefined) {
          curvar = 'cases';
        }
        var curdat = window.cur_trscope_vega_dat;
        if (curdat === undefined) {
          curdat = 'daily';
        }
        var curyax = window.cur_trscope_vega_yax;
        if (curyax === undefined) {
          curyax = 'linear';
        }
        makePlot(curvar, curdat, curyax);
      },
      resize: function(width, height) {
        // var factor = width / 500;
        // el.firstChild.setAttribute("style", `transform: scale(${factor},${factor}); transform-origin: top left;`);
      }
    };
  }
});
