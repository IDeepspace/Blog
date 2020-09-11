{# wobble窗口摆动特效 #}
{% if theme.wobble %}
  <script src="/js/wobblewindow.js"></script>
  <script>
    //只在桌面版网页启用特效
    if( window.innerWidth > 768  ){
      $(document).ready(function () {
        {% if theme.wobble.header %}
          $('#header').wobbleWindow({
            radius: {{ theme.wobble.radius }},
            movementTop: false,
            movementLeft: false,
            movementRight: false,
            debug: false,
          });
        {% endif %}

        {% if theme.wobble.sidebar %}
          $('#sidebar').wobbleWindow({
            radius: {{ theme.wobble.radius }},
            movementLeft: false,
            movementTop: false,
            movementBottom: false,
            position: 'fixed',
            debug: false,
          });
        {% endif %}

        {% if theme.wobble.footer %}
          $('#footer').wobbleWindow({
            radius: {{ theme.wobble.radius }},
            movementBottom: false,
            movementLeft: false,
            movementRight: false,
            offsetX: {{ theme.wobble.offset }},
            position: 'absolute',
            debug: false,
          });
        {% endif %}
      });
    }
  </script>
{% endif %}

{# 随机三角丝带背景 #}
{% if theme.evanyou %}
  <canvas id="evanyou"></canvas>
  <style>
    #evanyou {
      position: fixed;
      width: 100%;
      height: 100%;
      top: 0;
      left: 0;
      z-index: -1;
    }
  </style>
  <script src="/js/evan-you.js"></script>
{% endif %}