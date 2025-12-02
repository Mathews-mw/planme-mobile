allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)


// --- ISAR NAMESPACE FIX ---
subprojects {
    afterEvaluate {
        // Verifica se o subprojeto é a biblioteca do Isar que está falhando
        if (project.name == "isar_flutter_libs") {
            try {
                // Tenta encontrar a extensão 'android' do plugin
                val android = project.extensions.findByName("android")
                
                // Se encontrou, usa reflection para forçar o namespace
                // (Usamos reflection para evitar ter que importar classes do Android Plugin neste arquivo raiz)
                if (android != null) {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespace.invoke(android, "dev.isar.isar_flutter_libs")
                }
            } catch (e: Exception) {
                println("Erro ao tentar configurar namespace do Isar: $e")
            }
        }
    }
}

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
