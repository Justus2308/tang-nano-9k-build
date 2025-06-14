Basic build process using the [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build).

Targets the Tang Nano 9K in its current configuration but can easily be adapted to other Gowin boards ([more](https://github.com/YosysHQ/apicula/wiki)).

## Usage

Place all of your Verilog `.v` sources and your `.cst` constraints in `src`.

Build:
```sh
make -r
```

Load:
```sh
make -r load
```

For more info:
```sh
make help
```
