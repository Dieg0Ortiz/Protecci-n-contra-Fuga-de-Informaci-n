import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {

    // Campo de texto seguro utilizado para proteger contra capturas de pantalla.
    // iOS trata las vistas dentro del contenedor de un campo seguro como
    // contenido protegido, mostrándolas en blanco durante capturas.
    private var secureTextField: UITextField?

    override func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)

        guard let windowScene = scene as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        makeWindowSecure(window: window)
    }

    /// Envuelve el contenido de la ventana en un contenedor seguro que impide
    /// capturas de pantalla y grabaciones de pantalla en iOS.
    private func makeWindowSecure(window: UIWindow) {
        let field = UITextField()
        field.isSecureTextEntry = true
        field.translatesAutoresizingMaskIntoConstraints = false

        window.addSubview(field)
        field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
        field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true

        // Obtenemos la vista de contenedor seguro del campo de texto.
        // Esta vista hereda la protección anti-captura de iOS.
        window.layer.superlayer?.addSublayer(field.layer)
        field.layer.sublayers?.last?.addSublayer(window.layer)

        self.secureTextField = field
    }
}
