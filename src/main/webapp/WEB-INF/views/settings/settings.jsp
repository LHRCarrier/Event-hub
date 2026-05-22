<div id="page-settings" class="page-content d-none">
    <h2 class="mb-6">Settings</h2>
    
    <div class="row">
        <div class="col-12">
            <div class="bg-white rounded-xl p-8 shadow-sm">
                <h3 class="font-bold text-lg mb-6">Header Wallpaper</h3>
                
                <div class="mb-8">
                    <label class="form-label font-medium mb-4">Choose from presets:</label>
                    <div class="row row-cols-2 row-cols-md-3 gap-4">
                        <div class="wallpaper-item cursor-pointer rounded-xl overflow-hidden border-2 border-transparent" style="transition: all 0.2s;" data-wallpaper="linear">
                            <div class="h-28" style="background: linear-gradient(to right, #1e88e5, #42a5f5);"></div>
                            <p class="text-center text-sm mt-3 text-gray-600">Gradient 1</p>
                        </div>
                        <div class="wallpaper-item cursor-pointer rounded-xl overflow-hidden border-2 border-transparent" style="transition: all 0.2s;" data-wallpaper="gradient2">
                            <div class="h-28" style="background: linear-gradient(to right, #a855f7, #ec4899);"></div>
                            <p class="text-center text-sm mt-3 text-gray-600">Gradient 2</p>
                        </div>
                        <div class="wallpaper-item cursor-pointer rounded-xl overflow-hidden border-2 border-transparent" style="transition: all 0.2s;" data-wallpaper="gradient3">
                            <div class="h-28" style="background: linear-gradient(to right, #14b8a6, #22d3ee);"></div>
                            <p class="text-center text-sm mt-3 text-gray-600">Gradient 3</p>
                        </div>
                        <div class="wallpaper-item cursor-pointer rounded-xl overflow-hidden border-2 border-transparent" style="transition: all 0.2s;" data-wallpaper="gradient4">
                            <div class="h-28" style="background: linear-gradient(to right, #f97316, #ef4444);"></div>
                            <p class="text-center text-sm mt-3 text-gray-600">Gradient 4</p>
                        </div>
                        <div class="wallpaper-item cursor-pointer rounded-xl overflow-hidden border-2 border-transparent" style="transition: all 0.2s;" data-wallpaper="gradient5">
                            <div class="h-28" style="background: linear-gradient(to right, #6366f1, #a855f7);"></div>
                            <p class="text-center text-sm mt-3 text-gray-600">Gradient 5</p>
                        </div>
                        <div class="wallpaper-item cursor-pointer rounded-xl overflow-hidden border-2 border-transparent" style="transition: all 0.2s;" data-wallpaper="gradient6">
                            <div class="h-28" style="background: linear-gradient(to right, #22c55e, #14b8a6);"></div>
                            <p class="text-center text-sm mt-3 text-gray-600">Gradient 6</p>
                        </div>
                    </div>
                </div>
                
                <div class="mb-8">
                    <label class="form-label font-medium mb-4">Or upload your own image:</label>
                    <div id="wallpaperUploadArea" class="border-2 border-dashed rounded-xl p-10 text-center border-gray-200" style="min-height: 180px; cursor: pointer;">
                        <i class="fas fa-upload text-gray-400 text-5xl mb-4"></i>
                        <p class="text-gray-500 text-lg">Click or drag to upload wallpaper</p>
                        <p class="text-sm text-gray-400 mt-2">Supported formats: JPG, PNG (max 2MB)</p>
                        <input type="file" id="wallpaperFileInput" accept="image/jpeg,image/png" class="d-none">
                    </div>
                </div>
                
                <div id="currentWallpaperPreview" class="mb-6" style="display: none;">
                    <label class="form-label font-medium mb-3">Current Wallpaper Preview:</label>
                    <div id="wallpaperPreview" class="rounded-xl overflow-hidden h-40 border border-gray-200" style="background-size: cover; background-position: center;"></div>
                </div>
                
                <div class="d-flex gap-3">
                    <button id="resetWallpaperBtn" class="btn btn-outline-danger">
                        <i class="fas fa-trash mr-2"></i> Clear Wallpaper
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>