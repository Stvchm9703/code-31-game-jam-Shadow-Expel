using System.Collections.Generic;
using Unity.Entities.UniversalDelegates;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;


public class SceneSetData 
{
    public string SceneName;
    public List<ItemDataRef> ItemDataRefs;
}
public class ItemDataListViewData
{
    public string FieldName;
    public string FieldValue;
    public string FieldType;
    public bool IsSync;
}


public class ItemDataListView : EditorWindow
{
    [SerializeField]
    private VisualTreeAsset m_VisualTreeAsset = default;
    private List<SceneSetData> SceneSetDatas = new List<SceneSetData>();
    
    [MenuItem("Window/Data Toolkit/Item Data Editor")]
    public static void ShowEditor()
    {
        ItemDataListView wnd = GetWindow<ItemDataListView>();
        wnd.titleContent = new GUIContent("Item Data Editor");
    }

    public void CreateGUI()
    {
        // Each editor window contains a root VisualElement object
        VisualElement root = rootVisualElement;

        // VisualElements objects can contain other VisualElement following a tree hierarchy.
        VisualElement label = new Label("Hello World! From C#");
        root.Add(label);

        // Instantiate UXML
        VisualElement labelFromUXML = m_VisualTreeAsset.Instantiate();
        root.Add(labelFromUXML);
        
        
        m_VisualTreeAsset.CloneTree(rootVisualElement);
        var treeView = rootVisualElement.Q<MultiColumnTreeView>();
    
        // Call MultiColumnTreeView.SetRootItems() to populate the data in the tree.
        // treeView.SetRootItems(SceneSetDatas);
    
        //
        // treeView.columns["name"].bindCell = (VisualElement element, int index) =>
        //     (element as Label).text = treeView.GetItemDataForIndex<IPlanetOrGroup>(index).name;
        /**
            <ui:Column name="field_name" title="Field Name" width="80" />
			<ui:Column name="field_value" title="Field Value" width="120" />
            <ui:Column name="field_type" title="Type" width="80" />
            <ui:Column name="is_sync" title="is sync" width="80" />
        */
        
        treeView.columns["item_name"].makeCell = () => new Label();
        treeView.columns["is_sync"].makeCell = () => new Toggle();
        
        
        
        // treeView.columns["field_name"].bindCell = (VisualElement element, int index) =>
        //     (element as Label).text = treeView.GetItemDataForIndex<IDisplayTreeViewItem>(index).DisplayName;
        // treeView.columns["field_value"].bindCell = (VisualElement element, int index) =>
        //     (element as Label).text = treeView.GetItemDataForIndex<IDisplayTreeViewItem>(index).count.ToString();
        // treeView.columns["field_type"].bindCell = (VisualElement element, int index) =>
        //     (element as Label).text = treeView.GetItemDataForIndex<IDisplayTreeViewItem>(index).icon;
        // treeView.columns["is_sync"].bindCell = (VisualElement element, int index) =>
        // {
        //     (element as Toggle).text = treeView.GetItemDataForIndex<IDisplayTreeViewItem>(index).id;
        //     (element as Toggle).value = false;
        // };
    }
    
  
}
