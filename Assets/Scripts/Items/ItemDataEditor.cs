using System.Collections.Generic;
using System.Linq;
using Unity.VisualScripting;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UIElements;


public class ItemDataEditor : EditorWindow
{
    [SerializeField]
    private int m_SelectedIndex = -1;

    private VisualElement m_RightPane;

    [MenuItem("Window/Data Toolkit/Item Data Editor")]
    public static void ShowEditor()
    {
        // This method is called when the user selects the menu item in the Editor.
        EditorWindow wnd = GetWindow<ItemDataEditor>();
        wnd.titleContent = new GUIContent("Item Data Editor");

        // Limit size of the window.
        wnd.minSize = new Vector2(450, 200);
        wnd.maxSize = new Vector2(1920, 720);
    }


    public void CreateGUI()
    {
        // Add your UI controls here
        var root = this.rootVisualElement;
        root.Add(new Label("Hello, Unity!"));

        // get all scene
        var allObjectGuids = AssetDatabase.FindAssets("t:Scene", new string[] { "Assets/Scenes" });
        foreach (var objGuid in allObjectGuids)
        {
            // var sceneAsset = AssetDatabase.LoadAssetAtPath<SceneAsset>(AssetDatabase.GUIDToAssetPath(objGuid));
            // root.Add(sceneObj.name);
            var assetPath = AssetDatabase.GUIDToAssetPath(objGuid);
            root.Add(new Label(assetPath) );

            var sceneObj = EditorSceneManager.OpenPreviewScene(assetPath);
            
            List<ItemDataRef> itemDataRefs = new List<ItemDataRef>();

            foreach (var obj in sceneObj.GetRootGameObjects())
            {
                var objItemDataRefs = obj.GetComponentsInChildren<ItemDataRef>();
                itemDataRefs.AddRange(objItemDataRefs);     
            }

            // UIElements.TableView tableView = new TableView();
            var sceneTreeView = new ListView();
            sceneTreeView.makeItem = () => new Label();
            sceneTreeView.bindItem = (element, i) =>
            {
                (element as Label).text =  itemDataRefs[i].name;
            };
            sceneTreeView.itemsSource = itemDataRefs;
            root.Add(sceneTreeView);
            
            // Debug.Log(sceneObj.name);
        }
    }

    void SerializedItemData()
    {
        // var data = this.itemData.objectReferenceValue as InventoryItem;
    }
}