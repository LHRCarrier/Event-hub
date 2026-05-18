<div id="page-profile" class="page-content d-none">
    <h2 class="mb-4">Profile Settings</h2>
    <div class="bg-white rounded-xl p-6 max-w-2xl mx-auto">
        <div class="text-center mb-6">
            <div class="relative inline-block">
                <div id="avatarContainer" class="w-24 h-24 rounded-full bg-gradient-to-br from-purple-500 to-pink-500 flex items-center justify-center mx-auto cursor-pointer overflow-hidden border-4 border-white shadow-lg hover:shadow-xl transition-shadow">
                    <img id="avatarImage" src="" alt="Avatar" class="w-full h-full object-cover" style="display: none;">
                    <span id="avatarInitial" class="text-white text-3xl font-bold">U</span>
                </div>
                <div class="absolute bottom-0 right-0 w-8 h-8 bg-primary rounded-full flex items-center justify-center cursor-pointer hover:bg-primary-dark transition-colors shadow-md">
                    <i class="fas fa-camera text-white text-sm"></i>
                </div>
                <input type="file" id="avatarFileInput" accept="image/jpeg,image/png" class="d-none">
                <p class="text-sm text-gray-500 mt-2">Click to upload or drag image</p>
            </div>
            <div id="avatarUploadStatus" class="mt-2 text-sm"></div>
        </div>
        
        <form id="profileForm">
            <div class="mb-4">
                <label class="form-label font-medium">Username</label>
                <input type="text" class="form-control" id="profileUsername" readonly>
            </div>
            <div class="mb-4">
                <label class="form-label font-medium">Email</label>
                <input type="email" class="form-control" id="profileEmail">
            </div>
            <div class="mb-4">
                <label class="form-label font-medium">Phone</label>
                <input type="text" class="form-control" id="profilePhone" placeholder="Enter phone number">
            </div>
            <div class="mb-4">
                <label class="form-label font-medium">Real Name</label>
                <input type="text" class="form-control" id="profileRealName" placeholder="Enter real name">
            </div>
            <div class="d-flex gap-3">
                <button type="button" class="btn btn-secondary" onclick="showPage('home')">Cancel</button>
                <button type="submit" class="btn btn-primary ms-auto">Update Profile</button>
            </div>
        </form>
        
        <div id="avatarPreviewModal" class="modal fade" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Preview Avatar</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="text-center">
                            <img id="previewImage" src="" alt="Preview" class="w-50 h-auto rounded-lg">
                        </div>
                        <div class="mt-4">
                            <p id="previewFileName" class="text-sm text-gray-500"></p>
                            <p id="previewFileSize" class="text-sm text-gray-500"></p>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="confirmUploadBtn">Upload Avatar</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>