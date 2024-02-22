/*codigo extraido de 

https://parzibyte.me/blog/2023/02/28/javascript-tabular-datos-limite-longitud-separador-relleno/

*/


const separarCadenaEnArregloSiSuperaLongitud = (cadena, maximaLongitud) => {
    const resultado = [];
    let indice = 0;
    while (indice < cadena.length) {
        const pedazo = cadena.substring(indice, indice + maximaLongitud);
        indice += maximaLongitud;
        resultado.push(pedazo);
    }
    return resultado;
}

const dividirCadenasYEncontrarMayorConteoDeBloques = (contenidosConMaximaLongitud) => {
    let mayorConteoDeCadenasSeparadas = 0;
    const cadenasSeparadas = [];
    for (const contenido of contenidosConMaximaLongitud) {
        const separadas = separarCadenaEnArregloSiSuperaLongitud(contenido.contenido, contenido.maximaLongitud);
        cadenasSeparadas.push({ separadas, maximaLongitud: contenido.maximaLongitud });
        if (separadas.length > mayorConteoDeCadenasSeparadas) {
            mayorConteoDeCadenasSeparadas = separadas.length;
        }
    }
    return [cadenasSeparadas, mayorConteoDeCadenasSeparadas];
}


const tabularDatos = (cadenas, relleno, separadorColumnas) => {
    const [arreglosDeContenidosConMaximaLongitudSeparadas, mayorConteoDeBloques] = dividirCadenasYEncontrarMayorConteoDeBloques(cadenas)
    let indice = 0;
    const lineas = [];
    while (indice < mayorConteoDeBloques) {
        let linea = "";
        for (const contenidos of arreglosDeContenidosConMaximaLongitudSeparadas) {
            let cadena = "";
            if (indice < contenidos.separadas.length) {
                cadena = contenidos.separadas[indice];
            }
            if (cadena.length < contenidos.maximaLongitud) {
                cadena = cadena + relleno.repeat(contenidos.maximaLongitud - cadena.length);
            }
            linea += cadena + separadorColumnas;
        }
        lineas.push(linea);
        indice++;
    }
    return lineas;
}

// estas funciones si las hice yo XD
const generarSeparacion=(numCols)=>{
    const separadorColumnasEnSeparador = "+";
    let sepa=[];
    for(let i=0;i<numCols;i++){
        sepa.push({ contenido: "-", maximaLongitud:20 });
    }
    const lineasSeparador = tabularDatos(sepa, "-", separadorColumnasEnSeparador);

    return lineasSeparador[0];

}

const generarEncabezados=(listacolumnas)=>{
    const longitud = 20;
    const separadorColumnas = "|";
    const columnasEncabezado = [];

    for(i=0;i<listacolumnas.length;i++){
        columnasEncabezado.push({ contenido: listacolumnas[i], maximaLongitud:longitud });
    }

    const lineasEncabezado = tabularDatos(columnasEncabezado, " ", separadorColumnas);

    let filas="";
    for(let i=0;i<lineasEncabezado.length;i++){
        if(lineasEncabezado.length>1 && i<lineasEncabezado.length-1){
            filas+=lineasEncabezado[i]+"\n";
        }else{
            filas+=lineasEncabezado[i];
        }
        
    }

    return filas;


    

}

const generarRegistros=(lista)=>{
    const longitud = 20;
    const separadorColumnas = "|";
    const columnasEncabezado = [];

    for(i=0;i<lista.length;i++){
        columnasEncabezado.push({ contenido: lista[i], maximaLongitud:longitud });
    }

    const lineasEncabezado = tabularDatos(columnasEncabezado, " ", separadorColumnas);
    let filas="";
    for(let i=0;i<lineasEncabezado.length;i++){
        if(lineasEncabezado.length>1 && i<lineasEncabezado.length-1){
            filas+=lineasEncabezado[i]+"\n";
        }else{
            filas+=lineasEncabezado[i];
        }
        
    }

    return filas;
}

/*console.log(generarSeparacion(3));
console.log(generarEncabezados(["nombre","apellido","edad"]));
console.log(generarSeparacion(3));
console.log(generarRegistros(["jose","perez","20"]));
console.log(generarSeparacion(3));
console.log(generarRegistros(["walter javier sadsad","perez","20"]));
console.log(generarSeparacion(3));*/
 

module.exports = {
    generarSeparacion,
    generarEncabezados,
    generarRegistros
};