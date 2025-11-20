<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Auth;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        // Register GoogleDriveService as a singleton but don't instantiate it unless needed
        $this->app->singleton(\App\Services\GoogleDriveService::class, function ($app) {
            // Only create if Google Drive credentials are configured
            if (env('GOOGLE_REFRESH_TOKEN')) {
                return new \App\Services\GoogleDriveService();
            }
            return null;
        });
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Share unread notifications count and list with all views
        view()->composer('*', function($view) {
            if (Auth::check()) {
                $user = Auth::user();
                $view->with('notifications', $user->unreadNotifications);
            }
        });
    }
}
