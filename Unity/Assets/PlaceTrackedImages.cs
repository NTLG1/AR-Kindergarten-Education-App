// using System;
// using System.Collections.Generic;
// using UnityEngine;
// using UnityEngine.XR.ARFoundation;
// using UnityEngine.XR.ARSubsystems;

// [RequireComponent(typeof(ARTrackedImageManager))]
// public class PlaceTrackedImages : MonoBehaviour
// {
//     // Reference to AR tracked image manager component
//     private ARTrackedImageManager _trackedImagesManager;

//     // List of prefabs to instantiate - these should be named the same
//     // as their corresponding 2D images in the reference image library 
//     public GameObject[] ArPrefabs;

//     private readonly Dictionary<string, GameObject> _instantiatedPrefabs = new Dictionary<string, GameObject>();
//     private Camera arCamera;

//      void Awake()
//     {
//         _trackedImagesManager = GetComponent<ARTrackedImageManager>();
//         arCamera = Camera.main; // Assuming the AR camera is tagged as "MainCamera"

//     }
//     private void OnEnable()
//     {
//         _trackedImagesManager.trackedImagesChanged += OnTrackedImagesChanged;
//     }
//     private void OnDisable()
//     {
//         _trackedImagesManager.trackedImagesChanged -= OnTrackedImagesChanged;
//     }

//     // //Event Handler
//     // private void OnTrackedImagesChanged(ARTrackedImagesChangedEventArgs eventArgs) {

//     //     // Loop through all new tracked images that have been dectected
//     //     foreach (var trackedImage in eventArgs.added) {
//     //         // Get the name of the reference image
//     //         var imageName = trackedImage.referenceImage.name;
//     //         // Now loop over the array of prefabs
//     //         foreach (var curPrefab in ArPrefabs) {
//     //             // Check weather this prefab matches the traked image name, and that
//     //             // the prefab hasn't already been created
//     //             if (string.Compare(curPrefab.name, imageName, StringComparison.OrdinalIgnoreCase) == 0
//     //             && !_instantiatedPrefabs.ContainsKey(imageName)) {
//     //                 // Instantiate the prefab, parenting it to the AR trackedImage
//     //                 var newPrefab = Instantiate(curPrefab, trackedImage.transform);
//     //                 // Add the created prefab to our array
//     //                 _instantiatedPrefabs[imageName] = newPrefab;
//     //             }
//     //         }
//     //     }

//     //     // For all prefabs that have been created so far, set them active or not depending
//     //     // on whether their corresponding image is currently being tracked
//     //     foreach (var trackedImage in eventArgs.updated) {
//     //         _instantiatedPrefabs[trackedImage.referenceImage.name]
//     //             .SetActive(trackedImage.trackingState == TrackingState.Tracking);
//     //     }

//     //     foreach (var trackedImage in eventArgs.removed) {
//     //         // Destroy its prefab
//     //         Destroy(_instantiatedPrefabs[trackedImage.referenceImage.name]);
//     //         // Also remove the instance from our array
//     //         _instantiatedPrefabs.Remove(trackedImage.referenceImage.name);
//     //         // Or, simply set the prefab instance to inactive
//     //         // _instantiatedPrefabs[trackedImage.referenceImage.name].SetActive(false);
//     //     }
//     // }

//     private void OnTrackedImagesChanged(ARTrackedImagesChangedEventArgs eventArgs)
//     {
//         // Loop through all new tracked images that have been detected
//         foreach (var trackedImage in eventArgs.added)
//         {
//             Debug.Log("Tracked image added: " + trackedImage.referenceImage.name);
//             Vector3 position = trackedImage.transform.position;
//             Quaternion rotation = trackedImage.transform.rotation;

//             // Get the name of the reference image
//             var imageName = trackedImage.referenceImage.name;

//             // Check if the prefab for this image is not already instantiated
//             if (!_instantiatedPrefabs.ContainsKey(imageName))
//             {
//                 // Find the corresponding prefab for this image
//                 var prefab = Array.Find(ArPrefabs, p => p.name.Equals(imageName, StringComparison.OrdinalIgnoreCase));
//                 if (prefab != null)
//                 {
//                     // Instantiate the prefab at the calculated position
//                     var newPrefab = Instantiate(prefab, position, rotation);
//                     // Parent the prefab to the AR trackedImage
//                     newPrefab.transform.parent = trackedImage.transform;
//                     // Add the created prefab to our dictionary
//                     _instantiatedPrefabs[imageName] = newPrefab;
//                 }
//             }
//         }

//     // For all prefabs that have been created so far, set them active or not depending
//     // on whether their corresponding image is currently being tracked
//     foreach (var trackedImage in eventArgs.updated)
//     {
//         Debug.Log("Tracked image updated: " + trackedImage.referenceImage.name);

//         Vector3 position = trackedImage.transform.position;
//         Quaternion rotation = trackedImage.transform.rotation;
//         // Ensure the prefab exists in the dictionary
//         if (_instantiatedPrefabs.ContainsKey(trackedImage.referenceImage.name))
//         {
//             // Update the position of the prefab to match the tracked image
//             _instantiatedPrefabs[trackedImage.referenceImage.name].transform.position = position;
//             _instantiatedPrefabs[trackedImage.referenceImage.name].transform.rotation = rotation;
//             _instantiatedPrefabs[trackedImage.referenceImage.name].SetActive(trackedImage.trackingState == TrackingState.Tracking);
//         }
//     }
    

//     // For removed tracked images, destroy their corresponding prefab and remove it from the dictionary
//     foreach (var trackedImage in eventArgs.removed) {
//         Debug.Log("Tracked image removed: " + trackedImage.referenceImage.name);

//         if (_instantiatedPrefabs.ContainsKey(trackedImage.referenceImage.name)) {
//             // Destroy its prefab
//             Destroy(_instantiatedPrefabs[trackedImage.referenceImage.name]);
//             // Remove the instance from our dictionary
//             _instantiatedPrefabs.Remove(trackedImage.referenceImage.name);
//         }
//     }
// }
// }

using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;

[RequireComponent(typeof(ARTrackedImageManager))]
public class PlacePrefabOnTrackedImage : MonoBehaviour
{
    [SerializeField]
    private GameObject prefabToInstantiate;

    private ARTrackedImageManager trackedImageManager;
    private Dictionary<ARTrackedImage, GameObject> instantiatedPrefabs = new Dictionary<ARTrackedImage, GameObject>();

    private Camera arCamera;

    private void Awake()
    {
        trackedImageManager = GetComponent<ARTrackedImageManager>();
        arCamera = Camera.main; // Assuming the AR camera is tagged as "MainCamera"
    }

    private void OnEnable()
    {
        trackedImageManager.trackedImagesChanged += OnTrackedImagesChanged;
    }

    private void OnDisable()
    {
        trackedImageManager.trackedImagesChanged -= OnTrackedImagesChanged;
    }

    private void OnTrackedImagesChanged(ARTrackedImagesChangedEventArgs eventArgs)
    {
        foreach (var trackedImage in eventArgs.added)
        {
            Debug.Log("Tracked image added: " + trackedImage.referenceImage.name);

            // Get the position and rotation of the tracked image
            Vector3 position = trackedImage.transform.position;
            Quaternion rotation = trackedImage.transform.rotation;

            // Instantiate prefab at the position and rotation of the tracked image
            GameObject instantiatedPrefab = Instantiate(prefabToInstantiate, position, rotation);
            instantiatedPrefabs.Add(trackedImage, instantiatedPrefab);
        }

        foreach (var trackedImage in eventArgs.updated)
        {
            Debug.Log("Tracked image updated: " + trackedImage.referenceImage.name);

            if (instantiatedPrefabs.ContainsKey(trackedImage))
            {
                // Get the position and rotation of the tracked image
                Vector3 position = trackedImage.transform.position;
                Quaternion rotation = trackedImage.transform.rotation;
                // Update prefab position and rotation to match the tracked image
                instantiatedPrefabs[trackedImage].transform.position = trackedImage.transform.position;
                instantiatedPrefabs[trackedImage].transform.rotation = trackedImage.transform.rotation;
            }
        }

        foreach (var trackedImage in eventArgs.removed)
        {
            Debug.Log("Tracked image removed: " + trackedImage.referenceImage.name);

            if (instantiatedPrefabs.ContainsKey(trackedImage))
            {
                // Destroy the prefab associated with the removed tracked image
                Destroy(instantiatedPrefabs[trackedImage]);
                instantiatedPrefabs.Remove(trackedImage);
            }
        }
    }
}
