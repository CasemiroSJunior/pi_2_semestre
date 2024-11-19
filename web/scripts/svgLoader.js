    function loadSVG(filename, id) {
        fetch(`./assets/${filename}.svg`)
            .then(response => response.text())
            .then(svgContent => {
                const container = document.getElementById(id);
                container.innerHTML = svgContent + container.innerHTML;
            })
            .catch(error => console.error('Erro ao carregar o SVG:', error));
    }