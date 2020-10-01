//
//  UnityVersionButton.swift
//  Unity Hub
//
//  Created by Ryan Boyer on 9/22/20.
//

import SwiftUI

struct UnityVersionButton: View {
    var path: String
    var version: UnityVersion
    var hideRightSide: Bool = false
    
    var body: some View {
        HStack {
            SVGShapes.UnityCube()
                .frame(width: 16, height: 16)
                .padding(.leading, 12)
            Text(version.version)
                .font(.system(size: 12, weight: .bold))
                .help(path)
            
            if version.isAlpha() || version.isBeta() {
                PrereleaseTag(version: version)
            }
            if !hideRightSide {
                Spacer()
                ForEach(getInstalledModules()) { item in
                    if let icon = item.getIcon() {
                        icon
                            .frame(width: 16, height: 16)
                            .help(item.getDisplayName() ?? "")
                    }
                }
                Menu {
                    Button("Add Modules", action: {})
                    Button("Reveal in Finder", action: { NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: path) })
                    Button("Uninstall", action: {})
                } label: {}
                .menuStyle(BorderlessButtonMenuStyle())
                .frame(width: 16, height: 48)
                .padding(.trailing, 16)
            } else {
                Spacer()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .frame(minWidth: 64, maxWidth: .infinity, minHeight: 48, maxHeight: 48)
                .foregroundColor(Color(.windowBackgroundColor).opacity(0.375))
        )
        .foregroundColor(Color(.textColor))
        .frame(minWidth: 64, maxWidth: .infinity, minHeight: 48, maxHeight: 48)
        .padding(.vertical, 4)
    }
    
    func getInstalledModules() -> [UnityModule] {
        var unityModules: [UnityModule] = []
                
        let url = URL(fileURLWithPath: "\(path)/modules.json")
        do {
            let data = try Data(contentsOf: url)
            let modules: [ModuleJSON] = try! JSONDecoder().decode([ModuleJSON].self, from: data)
            
            for module in modules {
                if let unityModule = UnityModule(rawValue: module.id), !unityModules.contains(where: { $0.getDisplayName() == unityModule.getDisplayName() }) {
                    unityModules.append(unityModule)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return unityModules
    }
}
